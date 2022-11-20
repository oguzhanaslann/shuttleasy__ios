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

class ShuttleasyUserInfoRepository : UserInfoRepository {

    let localDatasource : UserInfoLocalDataSource

    init(userInfoLocalDataSource:UserInfoLocalDataSource) {
        self.localDatasource = userInfoLocalDataSource
    }

    func setOnboardingAsSeen() {
        Task.init {
            await localDatasource.setAsSeenOnboard()
        }
    }
}
