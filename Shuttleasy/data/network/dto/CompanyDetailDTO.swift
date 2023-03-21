//
//  CompanyDetailDTO.swift
//  Shuttleasy
//
//  Created by OguzhanMac on 21.03.2023.
//

import Foundation

struct CompanyDetailDTO : Codable {
    let id : Int
    let name : String
    let city : String
    let rating : Double
    let phoneNumber : String
    let email : String
    let votesNumber : Int


    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case city = "city"
        case rating = "rating"
        case phoneNumber = "phoneNumber"
        case email = "email"
        case votesNumber = "votesNumber"
    }
}