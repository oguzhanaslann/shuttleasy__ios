//
//  CompanyDetailDTO.swift
//  Shuttleasy
//
//  Created by OguzhanMac on 25.03.2023.
//

import Foundation

struct CompanyDetailDTO: Codable {
    let company: CompanyDTO?
    let commentDetails: [CommentDetailDTO]?

    enum CodingKeys: String, CodingKey {
        case company = "company"
        case commentDetails = "commentDetails"
    }
}

struct CommentDetailDTO : Codable {
    let passengerIdentity: Int?
    let rating: Int?
    let sessionId: Int?
    let date: String?
    let comment: String?
    let companyId: Int?
    let name: String?
    let surname: String?
    let profilePic: String?

    enum CodingKeys: String, CodingKey {
        case passengerIdentity = "passengerIdentity"
        case rating = "rating"
        case sessionId = "sessionId"
        case date = "date"
        case comment = "comment"
        case companyId = "companyId"
        case name = "name"
        case surname = "surname"
        case profilePic = "profilePic"
    }
}
