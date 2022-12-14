//
//  NetworkMapperExtensions.swift
//  Shuttleasy
//
//  Created by Oğuzhan Aslan on 20.11.2022.
//

import Foundation


extension UserAuthDTO {
    func toUserAuthenticationModel() -> UserAuthenticationModel {
        return UserAuthenticationModel(
            id: self.id,
            authenticationToken: self.authenticationToken,
            profileType: self.profileType
        )
    }
}


extension UserProfileDTO {
    func toUserProfile(isDarkMode : Bool) -> UserProfile {
        return UserProfile(
            profileType: self.profileType,
            profileImageUrl: self.profileImageUrl,
            profileName: self.profileName,
            profileSurname: self.profileSurname,
            profileEmail: self.profileEmail,
            profilePhone: self.profilePhone,
            darkMode: isDarkMode
        )
    }
}
