//
//  OnboardViewModel.swift
//  Shuttleasy
//
//  Created by Oğuzhan Aslan on 13.11.2022.
//

import Foundation

protocol UserInfoLocalDataSource {
    func setAsSeenOnboard()
}

class UserInfoLocalDataSourceImpl :UserInfoLocalDataSource  {
    static let onboardSeenKey = "shuttleasy.ios.onboard.seen"

    func setAsSeenOnboard() {
        UserDefaults.standard.set(true, forKey: UserInfoLocalDataSourceImpl.onboardSeenKey)
    }
}


protocol UserInfoRepository {
    func setOnboardingAsSeen()
}

class ShuttleasyUserInfoRepository : UserInfoRepository {

    let localDatasource : UserInfoLocalDataSource

    init(userInfoLocalDataSource:UserInfoLocalDataSource) {
        self.localDatasource = userInfoLocalDataSource
    }

    func setOnboardingAsSeen() {
        localDatasource.setAsSeenOnboard()
    }
}



class OnboardViewModel {

    let userInfoRepository : UserInfoRepository
    
    init(
        userInfoRepository : UserInfoRepository
    ) {
        self.userInfoRepository = userInfoRepository
    }
    
    func markOnboardAsSeen() {
        userInfoRepository.setOnboardingAsSeen()
    }
}
