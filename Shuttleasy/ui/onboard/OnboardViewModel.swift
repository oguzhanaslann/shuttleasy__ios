//
//  OnboardViewModel.swift
//  Shuttleasy
//
//  Created by Oğuzhan Aslan on 13.11.2022.
//

import Foundation

class OnboardViewModel: ViewModel {

    let userInfoRepository : UserRepository
    
    init(
        userInfoRepository : UserRepository
    ) {
        self.userInfoRepository = userInfoRepository
    }
    
    func markOnboardAsSeen() {
        userInfoRepository.setOnboardingAsSeen()
    }
}
