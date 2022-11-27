//
//  UserInfoRepository.swift
//  Shuttleasy
//
//  Created by Oğuzhan Aslan on 13.11.2022.
//

import Foundation

protocol UserInfoRepository {
    func setOnboardingAsSeen()
}

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
    
    func signUpUser(email: String, password: String) async throws -> Bool {
        let authDTO = try await networkDatasource.signUpUser(email: email, password: password)
        await localDatasource.saveUserAuthData(model: authDTO.toUserAuthenticationModel())
        await localDatasource.setAsLoggedIn()
        return true
    }
}
