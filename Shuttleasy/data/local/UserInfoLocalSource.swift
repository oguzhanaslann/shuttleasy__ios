//
//  UserInfoLocalSource.swift
//  Shuttleasy
//
//  Created by Oğuzhan Aslan on 13.11.2022.
//

import Foundation

protocol UserInfoLocalDataSource {
    func setAsSeenOnboard() async
    func setAsLoggedIn() async
    func saveUserAuthData(model :  UserAuthenticationModel) async
    func saveAuthToken(token : String) async
    func getUserProfileType(defaultValue: ProfileType) async -> ProfileType
    func setAsLoggedOut(clearWholeData: Bool) async
    func saveUserProfile(userProfile : UserProfile) async
    func getUserProfile() async throws -> UserProfile
    func saveDarkModePreference(isDarkMode: Bool) async
    func getUserId() -> Int?
    func isDarkMode() -> Bool
}

class UserInfoLocalDataSourceImpl :UserInfoLocalDataSource  {
    let memoryDataSource : MemoryDataSource
    let shuttleasyUserDefaults: ShuttleasyUserDefaults

    init(memoryDataSource : MemoryDataSource , shuttleasyUserDefaults: ShuttleasyUserDefaults) {
        self.memoryDataSource = memoryDataSource
        self.shuttleasyUserDefaults = shuttleasyUserDefaults
    }
    
    func setAsSeenOnboard() async {
        await shuttleasyUserDefaults.setAsSeenOnboard()
    }
    

    func setAsLoggedIn() async {
        await shuttleasyUserDefaults.setAsLoggedIn()
    }
    
    func saveUserAuthData(model: UserAuthenticationModel) async {
        await shuttleasyUserDefaults.saveUserAuthData(model: model)
        memoryDataSource.setAuthToken(token: model.authenticationToken)
    }

    func saveAuthToken(token: String) async {
        await shuttleasyUserDefaults.saveAuthToken(token: token)
        memoryDataSource.setAuthToken(token: token)
    }

    func setAsLoggedOut(clearWholeData: Bool) async {
        await shuttleasyUserDefaults.setAsLoggedOut(clearWholeData: clearWholeData)
        if clearWholeData {
           memoryDataSource.setAuthToken(token: nil) 
        }
    }

    func getUserProfileType(defaultValue: ProfileType) async -> ProfileType {
        let profileType = await shuttleasyUserDefaults.getUserProfileType(defaultValue: defaultValue)
        return profileType
    }
    
    func saveUserProfile(userProfile: UserProfile) async {
        await shuttleasyUserDefaults.saveUserProfile(userProfile: userProfile)
    }
    
    func getUserProfile() async throws -> UserProfile {
        return  try await shuttleasyUserDefaults.getUserProfile()
    }
    
    func getUserId() -> Int? {
        return shuttleasyUserDefaults.getUserId()
    }
    
    func saveDarkModePreference(isDarkMode: Bool) async {
        await shuttleasyUserDefaults.saveDarkModePreference(isDarkMode: isDarkMode)
    }

    func isDarkMode() -> Bool {
        return shuttleasyUserDefaults.isDarkMode()
    }
}
