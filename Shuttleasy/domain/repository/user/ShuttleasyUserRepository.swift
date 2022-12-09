//
//  ShuttleasyUserRepository.swift
//  Shuttleasy
//
//  Created by Oğuzhan Aslan on 3.12.2022.
//

import Foundation

class ShuttleasyUserRepository : UserInfoRepository, Authenticator {
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
    
    
    func signInUser(email: String, password: String) async throws -> Bool {
        let authDTO = try await networkDatasource.signInUser(email: email, password: password)
        await localDatasource.saveUserAuthData(model: authDTO.toUserAuthenticationModel())
        await localDatasource.setAsLoggedIn()
        return true
    }
    
    func signUpUser(
        email: String,
        password: String,
        name :String,
        surname: String,
        phone : String
    ) async throws -> Bool {
        let authDTO = try await networkDatasource.signUpUser(
            email: email,
            password: password,
            name: name,
            surname: surname,
            phone: phone
        )
        await localDatasource.saveUserAuthData(model: authDTO.toUserAuthenticationModel())
        await localDatasource.setAsLoggedIn()
        return true
    }

    func sendResetCodeTo(email: String) async throws -> Bool {
        let isSend = try await networkDatasource.sendResetCodeTo(email: email)
        return isSend
    }
    
    func sendResetCode(code: String, email:String) async throws -> Bool {
        let token = try await networkDatasource.sendResetCode(code: code, email : email)
        await localDatasource.saveAuthToken(token: token)
        return token.isEmpty.not()
    }
    
    func resetPassword(password: String, passwordAgain: String) async throws -> Bool {
        let isReset = try await networkDatasource.resetPassword(password: password, passwordAgain: passwordAgain)
        return isReset
    }
        
    func getUserProfile() async -> Result<UserProfile, Error> {
        do {
            let userProfileDTO = try await networkDatasource.getUserProfile()
            let isDarkMode = await localDatasource.isDarkMode()
            //await localDatasource.saveUserProfile(userProfile: userProfile)
            let userProfile = userProfileDTO.toUserProfile(isDarkMode: isDarkMode)
            return .success(userProfile)
        } catch {
            return .failure(error)
        }
    }

    func editProfile(profileEdit: ProfileEdit) async -> Result<UserProfile, Error> {
        do {
            let userProfileDTO = try await networkDatasource.editProfile(profileEdit: profileEdit)
            let isDarkMode = await localDatasource.isDarkMode()
            let userProfile = userProfileDTO.toUserProfile(isDarkMode: isDarkMode)
            //await localDatasource.saveUserProfile(userProfile: userProfile)
            return .success(userProfile)
        } catch {
            return .failure(error)
        }
    }

}
