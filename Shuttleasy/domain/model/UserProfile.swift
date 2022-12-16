//
//  UserProfile.swift
//  Shuttleasy
//
//  Created by Oğuzhan Aslan on 3.12.2022.
//

import Foundation

struct UserProfile {
    let profileType: ProfileType
    let profileImageUrl: String
    let profileName: String
    let profileSurname: String
    let profileEmail: String
    let profilePhone: String
    let qrSeed: String?
    let darkMode: Bool
}

extension UserProfile {
    // fullname
    var fullName: String {
        return "\(profileName) \(profileSurname)"
    }
}
