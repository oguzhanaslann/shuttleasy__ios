//
//  ShuttleasyUserRepository.swift
//  Shuttleasy
//
//  Created by Oğuzhan Aslan on 3.12.2022.
//

import Foundation

let USER_ID_NOT_FOUND = 1001
let RESET_PASSWORD_TOKEN_NIL = 1002

class ShuttleasyUserRepository: BaseRepository, UserRepository, Authenticator {
    private let localDatasource : UserInfoLocalDataSource
    private let networkDatasource : UserNetworkDataSource

    init(userInfoLocalDataSource:UserInfoLocalDataSource, userNetworkDataSource: UserNetworkDataSource) {
        self.localDatasource = userInfoLocalDataSource
        self.networkDatasource = userNetworkDataSource
    }

    func setOnboardingAsSeen() {
        Task.init {
            await localDatasource.setAsSeenOnboard()
        }
    }

    func signInUser(email: String, password: String, isDriver: Bool) async -> Result<Bool,Error> {
        do {
            let authDTO: UserAuthDTO
        
            if shouldUseDummyData() {
                authDTO = dummyUserAuthDto(isDriver : isDriver)
            } else {
                authDTO = try await networkDatasource.signInUser(
                    email: email,
                    password: password,
                    isDriver : isDriver
                )
            }
            
            await localDatasource.saveUserAuthData(
                model: authDTO.toUserAuthenticationModel(
                    profileType: getProfileType(from : isDriver)
                )
            )
            await localDatasource.setAsLoggedIn()
            
            return .success(true)
        } catch {
            return .failure(parseProcessError(error))
        }
    }
    
    private func getProfileType(from isDriver: Bool) -> ProfileType {
        return isDriver ? .driver : .passenger
    }
    

    
    func signUpUser(
        email: String,
        password: String,
        name :String,
        surname: String,
        phone : String
    )  async -> Result<Bool,Error> {
        do {
            let authDTO: UserAuthDTO

            if shouldUseDummyData() {
              authDTO = dummyUserAuthDto(isDriver : false)
            } else {
             authDTO = try await networkDatasource.signUpUser(
                    email: email,
                    password: password,
                    name: name,
                    surname: surname,
                    phone: phone
                )
            }

            await localDatasource.saveUserAuthData(
                model: authDTO.toUserAuthenticationModel(profileType: .driver)
            )
            await localDatasource.setAsLoggedIn()
            
            return .success(true)
        } catch {
            return .failure(parseProcessError(error))
        }
    }

    func sendResetCodeTo(email: String) async -> Result<Bool,Error>  {
        do {
            let isSend : Bool

            if shouldUseDummyData() {
                isSend = true
            } else {
                isSend = try await networkDatasource.sendResetCodeTo(email: email)
            }

            return .success(isSend)
        } catch {
            return .failure(parseProcessError(error))
        }
    }
    
    func sendResetCode(code: String, email:String) async -> Result<Bool,Error>  {
        do {
            let token : String

            if shouldUseDummyData() {
                token = "123456"
            } else {
                if let newToken = try await networkDatasource.sendResetCode(code: code, email : email) {
                    token = newToken
                } else {
                    return.failure(NSError(domain: "Invalid code", code: RESET_PASSWORD_TOKEN_NIL))
                }
            }

            await localDatasource.saveAuthToken(token: token)
            return .success(token.isEmpty.not())
        } catch {
            return .failure(parseProcessError(error))
        }
    }
    
    func resetPassword(email : String, password: String) async -> Result<Bool,Error> {
        do {
            return .success(true) //TODO:
        } catch {
            return .failure(parseProcessError(error))
        }
    }
        
    func getUserProfile() async -> Result<UserProfile, Error> {
        do {
            await getAndSaveProfileFromNetwork()
            let userProfile = try await localDatasource.getUserProfile()
            return .success(userProfile)
        } catch {
            return .failure(parseProcessError(error))
        }
    }
    
    private func getAndSaveProfileFromNetwork() async {
        do {
            let userProfileDTO : UserProfileDTO

            let userId = localDatasource.getUserId()
            if shouldUseDummyData() {
                userProfileDTO = dummyUserProfileDto()
            } else if let currentId = userId {
                let userProfileType =  await localDatasource.getUserProfileType(defaultValue: .passenger)
                userProfileDTO = try await networkDatasource.getUserProfile(userId: currentId, isDriver: userProfileType == .driver)
            } else {
                throw NSError(domain: "User not found", code: USER_ID_NOT_FOUND)
            }
            
          
            let isDarkMode = localDatasource.isDarkMode()
            let userProfile = userProfileDTO.toUserProfile(isDarkMode: isDarkMode)
            
            await localDatasource.saveUserProfile(userProfile: userProfile)
        } catch {
            debugPrint("Error getting user profile -> \(error.localizedDescription)")
        }
    }

    func dummyUserProfileDto() -> UserProfileDTO {
        return UserProfileDTO(
            profileType: .passenger,
            profileImageUrl: "",
            profileName: "Adam",
            profileSurname: "Smith",
            profileEmail:"sample@sample.com",
            profilePhone: "5554443322",
            qrSeed: nil
         )
    }


    func editProfile(profileEdit: ProfileEdit) async -> Result<UserProfile, Error> {
        do {
            let userType = await localDatasource.getUserProfileType(defaultValue: ProfileType.passenger)
            let userProfileDTO = try await networkDatasource.editProfile(profileEdit: profileEdit, isDriver: userType == .driver)
            let isDarkMode = localDatasource.isDarkMode()
            await localDatasource.saveUserProfile(userProfile: userProfileDTO.toUserProfile(isDarkMode: isDarkMode))
            let userProfile = try await localDatasource.getUserProfile()
            return .success(userProfile)
        } catch {
            return .failure(parseProcessError(error))
        }
    }
    
    

    func deleteAccount(email: String, password: String) async -> Result<Bool, Error> {
        do {
            let isDeleted : Bool
            
            if shouldUseDummyData() {
                isDeleted = true
            } else {
                isDeleted = try await networkDatasource.deleteAccount(email: email, password: password)
            }
            
            if isDeleted {
                await localDatasource.setAsLoggedOut(clearWholeData: true)
            }
            return .success(isDeleted)
        } catch {
            return .failure(parseProcessError(error))
        }
    }
    
    
    func logOut() async -> Result<Void, Error> {
        await localDatasource.setAsLoggedOut(clearWholeData: false)
        return .success(())
    }

    
    func updateDarkModePreference(isDarkMode: Bool) async -> Result<Bool, Error> {
        await localDatasource.saveDarkModePreference(isDarkMode: isDarkMode)
        return .success(true)
    }
    
    func getUserProfileType() async -> ProfileType {
        if (shouldUseDummyData()) {
            return .driver
        } else {
            return await localDatasource.getUserProfileType(defaultValue: .passenger)
        }
    }
    
    
    func getActiveSessions() async -> Result<[ActiveSession], Error> {
        let userProfileType = await getUserProfileType()
        
        switch userProfileType {
            case .passenger:
                return await getPassengerActiveSessions()
            case .driver:
                return await getDriverActiveSessions()
        }
    }
    
    private func getPassengerActiveSessions() async -> Result<[ActiveSession], Error> {
        if shouldUseDummyData() {
            return .success(getDummyActiveSessions())
        } else {
            return await getPassengerActiveSessionsFromNetwork()
        }
    }
  
    private func getPassengerActiveSessionsFromNetwork() async -> Result<[ActiveSession], Error> {
        do {
            let activeSessionsDTO = try await networkDatasource.getPassengerActiveSessions()
            let activeSessions : [ActiveSession] = activeSessionsDTO.toActiveSessionList()
            return .success(activeSessions)
            
        } catch {
            return .failure(parseProcessError(error))
        }
    }
    
    private func getDriverActiveSessions() async -> Result<[ActiveSession], Error> {
        if shouldUseDummyData() {
            return .success(getDriverDummyActiveSessions())
        } else {
            return await getDriverActiveSessionsFromNetwork()
        }
    }
    
    private func getDriverActiveSessionsFromNetwork() async -> Result<[ActiveSession], Error> {
        do {
            let activeSessionsDTO = try await networkDatasource.getDriverActiveSessions()
            let activeSessions : [ActiveSession] = activeSessionsDTO.toActiveSessionList()
            return .success(activeSessions)
            
        } catch {
            return .failure(parseProcessError(error))
        }
    }
}

extension ActiveSessionDTO {
    func toActiveSessionList() -> [ActiveSession] {
        return self.map { dto in
            ActiveSession(
                sessionId: dto.id ?? 0 ,
                plateNumber: dto.licensePlate ?? "",
                destinationName: dto.destinationName ?? "",
                startDate: ShuttleasyDateFormatter.shared.tryParsingDateString(
                    dateString: dto.startTime ?? ""
                ) ?? Date() ,
                startLocation: CGPoint(
                    x: dto.latitudeStart?.toDoubleOrZero() ?? 0,
                    y: dto.longitudeStart?.toDoubleOrZero() ?? 0
                ),
                endLocation: CGPoint(
                    x: dto.latitudeFinal?.toDoubleOrZero() ?? 0  ,
                    y: dto.longitudeFinal?.toDoubleOrZero() ?? 0
                ),
                isReturn: dto.isReturn ?? false
            )
        }
    }
}

