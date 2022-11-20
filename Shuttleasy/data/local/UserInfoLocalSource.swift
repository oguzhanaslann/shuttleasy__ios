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
}

class UserInfoLocalDataSourceImpl :UserInfoLocalDataSource  {
    static let onboardSeenKey = HAS_USER_SEEN_ONBOARD_KEY
    static let loggedInKey = HAS_USER_LOGGED_IN_KEY

    private static let USER_ID_KEY = "USER_ID"
    private static let USER_AUTH_TOKEN_KEY = "USER_AUTH_TOKEN_KEY"
    private static let USER_PROFILE_TYPE_KEY = "USER_PROFILE_TYPE_KEY"
    
    func setAsSeenOnboard() async {
        UserDefaults.standard.set(true, forKey: UserInfoLocalDataSourceImpl.onboardSeenKey)
    }
    

    func setAsLoggedIn() async {
        UserDefaults.standard.set(true, forKey: UserInfoLocalDataSourceImpl.loggedInKey)
    }
    
    func saveUserAuthData(model: UserAuthenticationModel) async {
        UserDefaults.standard.set(model.id, forKey: UserInfoLocalDataSourceImpl.USER_ID_KEY)
        UserDefaults.standard.set(model.authenticationToken, forKey: UserInfoLocalDataSourceImpl.USER_AUTH_TOKEN_KEY)
        UserDefaults.standard.set(model.profileType.rawValue, forKey: UserInfoLocalDataSourceImpl.USER_PROFILE_TYPE_KEY)
    }


    
}
