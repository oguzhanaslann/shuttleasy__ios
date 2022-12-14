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
    func saveDarkModePreference(isDarkMode: Bool) async
    func isDarkMode() -> Bool
}

class UserInfoLocalDataSourceImpl :UserInfoLocalDataSource  {

    private static let onboardSeenKey = HAS_USER_SEEN_ONBOARD_KEY
    private static let loggedInKey = HAS_USER_LOGGED_IN_KEY
    private static let USER_ID_KEY = "USER_ID"
    private static let USER_AUTH_TOKEN_KEY = "USER_AUTH_TOKEN_KEY"
    private static let USER_PROFILE_TYPE_KEY = "USER_PROFILE_TYPE_KEY"
    private static let DARK_MODE_KEY = IS_DARK_MODE_KEY

    let memoryDataSource : MemoryDataSource

    init(memoryDataSource : MemoryDataSource) {
        self.memoryDataSource = memoryDataSource
    }
    
    func setAsSeenOnboard() async {
        UserDefaults.standard.set(true, forKey: UserInfoLocalDataSourceImpl.onboardSeenKey)
    }
    

    func setAsLoggedIn() async {
        UserDefaults.standard.set(true, forKey: UserInfoLocalDataSourceImpl.loggedInKey)
    }
    
    func saveUserAuthData(model: UserAuthenticationModel) async {
        UserDefaults.standard.set(model.id, forKey: UserInfoLocalDataSourceImpl.USER_ID_KEY)
        UserDefaults.standard.set(model.profileType.rawValue, forKey: UserInfoLocalDataSourceImpl.USER_PROFILE_TYPE_KEY)
        await saveAuthToken(token: model.authenticationToken)
    }

    func saveAuthToken(token: String) async {
        UserDefaults.standard.set(token, forKey: UserInfoLocalDataSourceImpl.USER_AUTH_TOKEN_KEY)
        memoryDataSource.setAuthToken(token: token)
    }

    func setAsLoggedOut(clearWholeData: Bool) async {
        UserDefaults.standard.set(false, forKey: UserInfoLocalDataSourceImpl.loggedInKey)
        if clearWholeData {
            UserDefaults.standard.removeObject(forKey: UserInfoLocalDataSourceImpl.USER_ID_KEY)
            UserDefaults.standard.removeObject(forKey: UserInfoLocalDataSourceImpl.USER_AUTH_TOKEN_KEY)
            UserDefaults.standard.removeObject(forKey: UserInfoLocalDataSourceImpl.USER_PROFILE_TYPE_KEY)
        }
    }

    func getUserProfileType(defaultValue: ProfileType) async -> ProfileType {
        let profileType = UserDefaults.standard.string(forKey: UserInfoLocalDataSourceImpl.USER_PROFILE_TYPE_KEY)
        if let profileType = profileType {
            return ProfileType(rawValue: profileType) ?? defaultValue
        }
        return defaultValue
    }
    
    func saveUserProfile(userProfile: UserProfile) async {
        // TODO:
    }

    func saveDarkModePreference(isDarkMode: Bool) async {
        UserDefaults.standard.set(isDarkMode, forKey: UserInfoLocalDataSourceImpl.DARK_MODE_KEY)
    }

    func isDarkMode() -> Bool {
        return UserDefaults.standard.bool(forKey: UserInfoLocalDataSourceImpl.DARK_MODE_KEY)
    }
}
