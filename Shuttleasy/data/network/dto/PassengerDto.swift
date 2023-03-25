//
//  PassengerDto.swift
//  Shuttleasy
//
//  Created by Oğuzhan Aslan on 13.12.2022.
//

import Foundation
import Alamofire

// MARK: - PassengerDto
struct PassengerDto: Codable {
    let id: Int?
    let profilePic: String?
    let name: String?
    let surname: String?
    let phoneNumber: String?
    let email: String?
    let city: String?
    let passengerAddress: String?
    let qrString: String?
    let isPayment: Bool?
    let token: String?

    enum CodingKeys: String, CodingKey {
        case id = "id"
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

// MARK: - Helper functions for creating encoders and decoders

func newJSONDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        decoder.dateDecodingStrategy = .iso8601
    }
    return decoder
}

func newJSONEncoder() -> JSONEncoder {
    let encoder = JSONEncoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        encoder.dateEncodingStrategy = .iso8601
    }
    return encoder
}


extension PassengerDto {
    func toUserAuthDTO() -> UserAuthDTO {
        return UserAuthDTO(
           id: id ?? 0,
           profilePic: profilePic ?? "",
           name: name ?? "",
           surname: surname ?? "",
           phoneNumber: phoneNumber ?? "",
           email: email ?? "",
           city: "",
           passengerAddress: "",
           qrString: qrString ?? "",
           token: token ?? ""
        )
    }
    
    func toUserProfileDTO() -> UserProfileDTO {
        return UserProfileDTO(
          profileType: .passenger,
          profileImageUrl:  profilePic ?? "",
          profileName:  name ?? "",
          profileSurname:  surname ?? "",
          profileEmail:  email ?? "",
          profilePhone:  phoneNumber ?? "",
          qrSeed: qrString ?? ""
        )
    }
}
