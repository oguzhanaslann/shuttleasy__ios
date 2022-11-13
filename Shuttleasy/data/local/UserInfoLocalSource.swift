//
//  UserInfoLocalSource.swift
//  Shuttleasy
//
//  Created by Oğuzhan Aslan on 13.11.2022.
//

import Foundation

protocol UserInfoLocalDataSource {
    func setAsSeenOnboard()
}

class UserInfoLocalDataSourceImpl :UserInfoLocalDataSource  {
    static let onboardSeenKey = HAS_USER_SEEN_ONBOARD_KEY

    func setAsSeenOnboard() {
        UserDefaults.standard.set(true, forKey: UserInfoLocalDataSourceImpl.onboardSeenKey)
    }
}
