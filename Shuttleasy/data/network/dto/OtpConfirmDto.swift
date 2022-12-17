//
//  OtpConfirmDto.swift
//  Shuttleasy
//
//  Created by Oğuzhan Aslan on 17.12.2022.
//

import Foundation

struct OtpConfirmDto: Codable {
    let email: String?
    let token: String?

    enum CodingKeys: String, CodingKey {
        case email = "email"
        case token = "token"
    }
}
