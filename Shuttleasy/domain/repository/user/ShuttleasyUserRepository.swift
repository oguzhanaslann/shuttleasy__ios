//
//  ShuttleasyUserRepository.swift
//  Shuttleasy
//
//  Created by Oğuzhan Aslan on 3.12.2022.
//

import Foundation

let USER_ID_NOT_FOUND = 1001

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
                authDTO = try await networkDatasource.signInUser(email: email, password: password,isDriver : isDriver)
            }
            
            await localDatasource.saveUserAuthData(model: authDTO.toUserAuthenticationModel())
            await localDatasource.setAsLoggedIn()
            
            return .success(true)
        } catch {
            return .failure(error)
        }
    }
    
    private func dummyUserAuthDto(isDriver:Bool) -> UserAuthDTO {
        let profileType: ProfileType
        
        if isDriver {
            profileType = .driver
        } else {
            profileType = .passenger
        }

        return UserAuthDTO(
            id: 1,
            authenticationToken: "",
            profileType : profileType,
            profilePic: "",
            name: "Oguzhan",
            surname: "Aslan",
            phoneNumber: "5398775750",
            qrString: "",
            email: "sample@gmail.com"
        )
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

            await localDatasource.saveUserAuthData(model: authDTO.toUserAuthenticationModel())
            await localDatasource.setAsLoggedIn()
            
            return .success(true)
        } catch {
            return .failure(error)
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
            return .failure(error)
        }
    }
    
    func sendResetCode(code: String, email:String) async -> Result<Bool,Error>  {
        do {
            let token : String

            if shouldUseDummyData() {
                token = ""
            } else {
                token = try await networkDatasource.sendResetCode(code: code, email : email)
            }

            await localDatasource.saveAuthToken(token: token)

            return .success(token.isEmpty.not())
        } catch {
            return .failure(error)
        }
    }
    
    func resetPassword(password: String, passwordAgain: String) async throws -> Bool {
        let authDTO : UserAuthDTO

        if shouldUseDummyData() {
            authDTO = dummyUserAuthDto(isDriver : false)
        } else {
            authDTO = try await networkDatasource.resetPassword(password: password, passwordAgain: passwordAgain)
        }

        await localDatasource.saveUserAuthData(model: authDTO.toUserAuthenticationModel())
        await localDatasource.setAsLoggedIn()
        return true
    }
        
    func getUserProfile() async -> Result<UserProfile, Error> {
        do {
            await getAndSaveProfileFromNetwork()
            let userProfile = try await localDatasource.getUserProfile()
            return .success(userProfile)
        } catch {
            return .failure(error)
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
            return .failure(error)
        }
    }
    
    

    func deleteAccount(email: String, password: String) async -> Result<Bool, Error> {
        do {
            let isDeleted = try await networkDatasource.deleteAccount(email: email, password: password)
            if isDeleted {
                await localDatasource.setAsLoggedOut(clearWholeData: true)
            }
            return .success(isDeleted)
        } catch {
            return .failure(error)
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
}
