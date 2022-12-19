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
    let companyName: String?
    let busID: Int?
    let busLicensePlate: String?
    let passengerCount: Int?
    let startTime: String?
    let driverID: Int?
    let isActive: Bool?
    let destinationID: Int?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case companyID = "companyId"
        case companyName = "companyName"
        case busID = "busId"
        case busLicensePlate = "busLicensePlate"
        case passengerCount = "passengerCount"
        case startTime = "startTime"
        case driverID = "driverId"
        case isActive = "isActive"
        case destinationID = "destinationId"
    }
}


