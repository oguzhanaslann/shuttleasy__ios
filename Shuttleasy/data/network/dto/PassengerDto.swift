//
//  PassengerDto.swift
//  Shuttleasy
//
//  Created by Oğuzhan Aslan on 13.12.2022.
//

import Foundation
// quicktype.io
class PassengerDto: Decodable {
  let id: Int
  let profilePic: String
  let name: String
  let surname: String
  let phoneNumber: String
  let email: String
  let city: String
  let passengerAddress: String
  let qrString: String
  let isPayment: Bool
  let token: String

  private enum CodingKeys: String, CodingKey {
    case id
    case profilePic = "profilePic"
    case name = "name"
    case surname = "surname"
    case phoneNumber = "phoneNumber"
    case email = "email"
    case city = "city"
    case passengerAddress = "passengerAddress"
    case qrString = "qrString"
    case isPayment = "isPayment"
    case token = "token"
  }
}


extension PassengerDto {
    func toUserAuthDTO() -> UserAuthDTO {
        return UserAuthDTO(
            id: id,
            authenticationToken: token,
            profileType: .passenger
        )
    }
    
    func toUserProfileDTO() -> UserProfileDTO {
        return UserProfileDTO(
          profileType: .passenger,
          profileImageUrl:  profilePic,
          profileName:  name,
          profileSurname:  surname,
          profileEmail:  email,
          profilePhone:  phoneNumber,
          qrSeed: qrString
        )
    }
}
