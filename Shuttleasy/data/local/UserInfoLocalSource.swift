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
    func isDarkMode() -> Bool
}

class UserInfoLocalDataSourceImpl :UserInfoLocalDataSource  {
    private static let onboardSeenKey = HAS_USER_SEEN_ONBOARD_KEY
    private static let loggedInKey = HAS_USER_LOGGED_IN_KEY
    private static let USER_ID_KEY = "USER_ID"
    private static let USER_AUTH_TOKEN_KEY = "USER_AUTH_TOKEN_KEY"
    private static let USER_PROFILE_TYPE_KEY = "USER_PROFILE_TYPE_KEY"
    private static let DARK_MODE_KEY = IS_DARK_MODE_KEY

    private static let USER_NAME_KEY = "USER_NAME_KEY"
    private static let USER_SURNAME_KEY = "USER_SURNAME_KEY"
    private static let USER_EMAIL_KEY = "USER_EMAIL_KEY"
    private static let USER_PROFILE_PIC_KEY = "USER_PROFILE_PIC_KEY"
    private static let USER_PHONE_NUMBER_KEY = "USER_PHONE_NUMBER_KEY"
    private static let USER_QR_STRING_KEY = "USER_QR_STRING_KEY"

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
        UserDefaults.standard.set(model.name, forKey: UserInfoLocalDataSourceImpl.USER_NAME_KEY)
        UserDefaults.standard.set(model.surname, forKey: UserInfoLocalDataSourceImpl.USER_SURNAME_KEY)
        UserDefaults.standard.set(model.email, forKey: UserInfoLocalDataSourceImpl.USER_EMAIL_KEY)
        UserDefaults.standard.set(model.profilePic, forKey: UserInfoLocalDataSourceImpl.USER_PROFILE_PIC_KEY)
        UserDefaults.standard.set(model.phoneNumber, forKey: UserInfoLocalDataSourceImpl.USER_PHONE_NUMBER_KEY)
        UserDefaults.standard.set(model.qrString, forKey: UserInfoLocalDataSourceImpl.USER_QR_STRING_KEY)
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
            UserDefaults.standard.removeObject(forKey: UserInfoLocalDataSourceImpl.USER_NAME_KEY)
            UserDefaults.standard.removeObject(forKey: UserInfoLocalDataSourceImpl.USER_SURNAME_KEY)
            UserDefaults.standard.removeObject(forKey: UserInfoLocalDataSourceImpl.USER_EMAIL_KEY)
            UserDefaults.standard.removeObject(forKey: UserInfoLocalDataSourceImpl.USER_PROFILE_PIC_KEY)
            UserDefaults.standard.removeObject(forKey: UserInfoLocalDataSourceImpl.USER_PHONE_NUMBER_KEY)
            UserDefaults.standard.removeObject(forKey: UserInfoLocalDataSourceImpl.USER_QR_STRING_KEY)  
            memoryDataSource.setAuthToken(token: nil)          
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
        UserDefaults.standard.set(userProfile.profileName, forKey: UserInfoLocalDataSourceImpl.USER_NAME_KEY)
        UserDefaults.standard.set(userProfile.profileSurname, forKey: UserInfoLocalDataSourceImpl.USER_SURNAME_KEY)
        UserDefaults.standard.set(userProfile.profileEmail, forKey: UserInfoLocalDataSourceImpl.USER_EMAIL_KEY)
        UserDefaults.standard.set(userProfile.profileImageUrl, forKey: UserInfoLocalDataSourceImpl.USER_PROFILE_PIC_KEY)
        UserDefaults.standard.set(userProfile.profilePhone, forKey: UserInfoLocalDataSourceImpl.USER_PHONE_NUMBER_KEY)
        UserDefaults.standard.set(userProfile.qrSeed, forKey: UserInfoLocalDataSourceImpl.USER_QR_STRING_KEY)
    }
    
    func getUserProfile() async throws -> UserProfile {
        return UserProfile(
            profileType: try await getUserProfileType(defaultValue: .passenger),
            profileImageUrl: UserDefaults.standard.string(forKey: UserInfoLocalDataSourceImpl.USER_PROFILE_PIC_KEY) ?? "",
            profileName: UserDefaults.standard.string(forKey: UserInfoLocalDataSourceImpl.USER_NAME_KEY) ?? "",
            profileSurname: UserDefaults.standard.string(forKey: UserInfoLocalDataSourceImpl.USER_SURNAME_KEY) ?? "",
            profileEmail: UserDefaults.standard.string(forKey: UserInfoLocalDataSourceImpl.USER_EMAIL_KEY) ?? "",
            profilePhone: UserDefaults.standard.string(forKey: UserInfoLocalDataSourceImpl.USER_PHONE_NUMBER_KEY) ?? "",
            qrSeed: UserDefaults.standard.string(forKey: UserInfoLocalDataSourceImpl.USER_QR_STRING_KEY),
            darkMode: isDarkMode()
        )
    }
    

    func saveDarkModePreference(isDarkMode: Bool) async {
        UserDefaults.standard.set(isDarkMode, forKey: UserInfoLocalDataSourceImpl.DARK_MODE_KEY)
    }

    func isDarkMode() -> Bool {
        return UserDefaults.standard.bool(forKey: UserInfoLocalDataSourceImpl.DARK_MODE_KEY)
    }
}
