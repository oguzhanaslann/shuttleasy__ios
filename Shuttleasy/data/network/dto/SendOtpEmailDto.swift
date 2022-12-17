//
//  SendOtpEmailDto.swift
//  Shuttleasy
//
//  Created by Oğuzhan Aslan on 17.12.2022.
//

import Foundation
import Alamofire

// MARK: - SendOtpEmailDto
struct SendOtpEmailDto: Codable {
    let id: Int?
    let email: String?
    let resetKey: String?
    let date: String?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case email = "email"
        case resetKey = "resetKey"
        case date = "date"
    }
}
