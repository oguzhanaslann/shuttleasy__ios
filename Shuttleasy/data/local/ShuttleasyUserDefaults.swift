//
//  ShuttleasyUserDefaults.swift
//  Shuttleasy
//
//  Created by Oğuzhan Aslan on 16.12.2022.
//

import Foundation

class ShuttleasyUserDefaults {
    static let shared = ShuttleasyUserDefaults()
    private init() {}

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

    private static let USER_FCM_ID = FCM_ID

    func setAsSeenOnboard() async {
        UserDefaults.standard.set(true, forKey: ShuttleasyUserDefaults.onboardSeenKey)
    }

    func setAsLoggedIn() async {
        UserDefaults.standard.set(true, forKey: ShuttleasyUserDefaults.loggedInKey)
    }
    
    func saveUserAuthData(model: UserAuthenticationModel) async {
        UserDefaults.standard.set(model.id, forKey: ShuttleasyUserDefaults.USER_ID_KEY)
        UserDefaults.standard.set(model.profileType.rawValue, forKey: ShuttleasyUserDefaults.USER_PROFILE_TYPE_KEY)
        await saveAuthToken(token: model.authenticationToken)
        UserDefaults.standard.set(model.name, forKey: ShuttleasyUserDefaults.USER_NAME_KEY)
        UserDefaults.standard.set(model.surname, forKey: ShuttleasyUserDefaults.USER_SURNAME_KEY)
        UserDefaults.standard.set(model.email, forKey: ShuttleasyUserDefaults.USER_EMAIL_KEY)
        UserDefaults.standard.set(model.profilePic, forKey: ShuttleasyUserDefaults.USER_PROFILE_PIC_KEY)
        UserDefaults.standard.set(model.phoneNumber, forKey: ShuttleasyUserDefaults.USER_PHONE_NUMBER_KEY)
        UserDefaults.standard.set(model.qrString, forKey: ShuttleasyUserDefaults.USER_QR_STRING_KEY)
    }

    func saveAuthToken(token: String) async {
        UserDefaults.standard.set(token, forKey: ShuttleasyUserDefaults.USER_AUTH_TOKEN_KEY)
    }
    
    //getAuthToken
    func getAuthToken() -> String? {
        return UserDefaults.standard.string(forKey: ShuttleasyUserDefaults.USER_AUTH_TOKEN_KEY)
    }

    func setAsLoggedOut(clearWholeData: Bool) async {
        UserDefaults.standard.set(false, forKey: ShuttleasyUserDefaults.loggedInKey)
        if clearWholeData {
            UserDefaults.standard.removeObject(forKey: ShuttleasyUserDefaults.USER_ID_KEY)
            UserDefaults.standard.removeObject(forKey: ShuttleasyUserDefaults.USER_AUTH_TOKEN_KEY)
            UserDefaults.standard.removeObject(forKey: ShuttleasyUserDefaults.USER_PROFILE_TYPE_KEY)
            UserDefaults.standard.removeObject(forKey: ShuttleasyUserDefaults.USER_NAME_KEY)
            UserDefaults.standard.removeObject(forKey: ShuttleasyUserDefaults.USER_SURNAME_KEY)
            UserDefaults.standard.removeObject(forKey: ShuttleasyUserDefaults.USER_EMAIL_KEY)
            UserDefaults.standard.removeObject(forKey: ShuttleasyUserDefaults.USER_PROFILE_PIC_KEY)
            UserDefaults.standard.removeObject(forKey: ShuttleasyUserDefaults.USER_PHONE_NUMBER_KEY)
            UserDefaults.standard.removeObject(forKey: ShuttleasyUserDefaults.USER_QR_STRING_KEY)
        }
    }

    func getUserProfileType(defaultValue: ProfileType) async -> ProfileType {
        let profileType = UserDefaults.standard.string(forKey: ShuttleasyUserDefaults.USER_PROFILE_TYPE_KEY)
        if let profileType = profileType {
            return ProfileType(rawValue: profileType) ?? defaultValue
        }
        return defaultValue
    }
    
    func saveUserProfile(userProfile: UserProfile) async {
        UserDefaults.standard.set(userProfile.profileName, forKey: ShuttleasyUserDefaults.USER_NAME_KEY)
        UserDefaults.standard.set(userProfile.profileSurname, forKey: ShuttleasyUserDefaults.USER_SURNAME_KEY)
        UserDefaults.standard.set(userProfile.profileEmail, forKey: ShuttleasyUserDefaults.USER_EMAIL_KEY)
        UserDefaults.standard.set(userProfile.profileImageUrl, forKey: ShuttleasyUserDefaults.USER_PROFILE_PIC_KEY)
        UserDefaults.standard.set(userProfile.profilePhone, forKey: ShuttleasyUserDefaults.USER_PHONE_NUMBER_KEY)
        UserDefaults.standard.set(userProfile.qrSeed, forKey: ShuttleasyUserDefaults.USER_QR_STRING_KEY)
        UserDefaults.standard.set(userProfile.profileType.rawValue, forKey: ShuttleasyUserDefaults.USER_PROFILE_TYPE_KEY)
    }
    
    func getUserProfile() async throws -> UserProfile {
        return UserProfile(
            profileType: try await getUserProfileType(defaultValue: .passenger),
            profileImageUrl: UserDefaults.standard.string(forKey: ShuttleasyUserDefaults.USER_PROFILE_PIC_KEY) ?? "",
            profileName: UserDefaults.standard.string(forKey: ShuttleasyUserDefaults.USER_NAME_KEY) ?? "",
            profileSurname: UserDefaults.standard.string(forKey: ShuttleasyUserDefaults.USER_SURNAME_KEY) ?? "",
            profileEmail: UserDefaults.standard.string(forKey: ShuttleasyUserDefaults.USER_EMAIL_KEY) ?? "",
            profilePhone: UserDefaults.standard.string(forKey: ShuttleasyUserDefaults.USER_PHONE_NUMBER_KEY) ?? "",
            qrSeed: UserDefaults.standard.string(forKey: ShuttleasyUserDefaults.USER_QR_STRING_KEY),
            darkMode: isDarkMode()
        )
    }
    

    func saveDarkModePreference(isDarkMode: Bool) async {
        UserDefaults.standard.set(isDarkMode, forKey: ShuttleasyUserDefaults.DARK_MODE_KEY)
    }

    func isDarkMode() -> Bool {
        return UserDefaults.standard.bool(forKey: ShuttleasyUserDefaults.DARK_MODE_KEY)
    }

    func getUserId() -> Int? {
        return UserDefaults.standard.integer(forKey: ShuttleasyUserDefaults.USER_ID_KEY)
    }

    func setFcmId(fcmId: String) async {
        UserDefaults.standard.set(fcmId, forKey: ShuttleasyUserDefaults.USER_FCM_ID)
    }


    func getFcmId() -> String? {
        return UserDefaults.standard.string(forKey: ShuttleasyUserDefaults.USER_FCM_ID) 
    } 

}
