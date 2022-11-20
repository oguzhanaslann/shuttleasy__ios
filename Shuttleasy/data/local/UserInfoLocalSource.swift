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
}

class UserInfoLocalDataSourceImpl :UserInfoLocalDataSource  {
    static let onboardSeenKey = HAS_USER_SEEN_ONBOARD_KEY
    static let loggedInKey = HAS_USER_LOGGED_IN_KEY

    func setAsSeenOnboard() async {
        UserDefaults.standard.set(true, forKey: UserInfoLocalDataSourceImpl.onboardSeenKey)
    }
    

    func setAsLoggedIn() async {
        UserDefaults.standard.set(true, forKey: UserInfoLocalDataSourceImpl.loggedInKey)
    }
    
}
