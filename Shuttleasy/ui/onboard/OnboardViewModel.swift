//
//  OnboardViewModel.swift
//  Shuttleasy
//
//  Created by Oğuzhan Aslan on 13.11.2022.
//

import Foundation

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
