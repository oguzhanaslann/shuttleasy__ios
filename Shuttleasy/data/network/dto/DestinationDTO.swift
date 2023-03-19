//
//  DestinationDTO.swift
//  Shuttleasy
//
//  Created by OguzhanMac on 19.03.2023.
//

import Foundation

struct DestinationDTO: Codable {
    let id: Int?
    let latitude: Double?
    let longtitude: Double?
    let locationName: String?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case latitude = "latitude"
        case longtitude = "longtitude"
        case locationName = "locationName"
    }
}
