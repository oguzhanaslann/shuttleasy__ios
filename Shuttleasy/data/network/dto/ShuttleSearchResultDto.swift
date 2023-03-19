//
//  ShuttleSearchResultDto.swift
//  Shuttleasy
//
//  Created by Oğuzhan Aslan on 19.12.2022.
//

import Foundation
import Alamofire

typealias ShuttleSearchResultDTO = [ShuttleSearchResultDTOElement]

struct ShuttleSearchResultDTOElement: Codable {
    let id: Int?
    let companyID: Int?
    let busID: Int?
    let passengerCount: Int?
    let startTime: String?
    let driverID: Int?
    let isActive: Bool?
    let startGeopoint: Int?
    let finalGeopoint: Int?
    let destinationName: String?
    let returning: Bool?
    let sessionDate: String?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case companyID = "companyId"
        case busID = "busId"
        case passengerCount = "passengerCount"
        case startTime = "startTime"
        case driverID = "driverId"
        case isActive = "isActive"
        case startGeopoint = "startGeopoint"
        case finalGeopoint = "finalGeopoint"
        case destinationName = "destinationName"
        case returning = "return"
        case sessionDate = "sessionDate"
    }
}
