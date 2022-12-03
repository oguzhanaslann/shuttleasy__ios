//
//  UserProfileDTO.swift
//  Shuttleasy
//
//  Created by Oğuzhan Aslan on 3.12.2022.
//

import Foundation

struct UserProfileDTO {
    let profileType: ProfileType
    let profileImageUrl: String
    let profileName: String
    let profileEmail: String
    let profilePhone: String
    let qrSeed: String?
}

