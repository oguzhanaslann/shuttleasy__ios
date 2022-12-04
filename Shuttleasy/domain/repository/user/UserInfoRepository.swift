//
//  UserInfoRepository.swift
//  Shuttleasy
//
//  Created by Oğuzhan Aslan on 13.11.2022.
//

import Foundation

protocol UserInfoRepository {
    func setOnboardingAsSeen()
    func getUserProfile() async -> Result<UserProfile, Error>
    func editProfile(profileEdit: ProfileEdit) async -> Result<UserProfile, Error>
    
}
