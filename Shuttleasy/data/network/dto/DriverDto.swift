//
//  DriverDto.swift
//  Shuttleasy
//
//  Created by Oğuzhan Aslan on 13.12.2022.
//

import Foundation

class DriverDto: Decodable {
    let id: Int
    let profilePic: String
    let name: String
    let surname: String
    let phoneNumber: String
    let companyId: Int
    let email: String
    let token: String
    let workerType: String

    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case profilePic = "profilePic"
        case name = "name"
        case surname = "surname"
        case phoneNumber = "phoneNumber"
        case companyId = "companyId"
        case email = "email"
        case token = "token"
        case workerType = "workerType"
    }
}


extension DriverDto {
    func toUserAuthDTO() -> UserAuthDTO {
        return UserAuthDTO(
            id: id,
            authenticationToken: token,
            profileType: .driver
        )
    }
    
    func toUserProfileDTO() -> UserProfileDTO {
        return UserProfileDTO(
            profileType: .driver,
            profileImageUrl: profilePic ,
            profileName:name,
            profileSurname: surname ,
            profileEmail: email ,
            profilePhone: phoneNumber ,
            qrSeed: nil
        )
    }
}
