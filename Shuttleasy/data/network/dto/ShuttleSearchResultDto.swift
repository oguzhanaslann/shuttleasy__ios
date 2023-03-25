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
    let companyDetail: CompanyDTO?
    let shuttleSessionDeparture: [ShuttleSessionDeparture]?
    let shuttleSessionReturn: [ShuttleSessionDeparture]?
    
    enum CodingKeys: String, CodingKey {
        case companyDetail = "companyDetail"
        case shuttleSessionDeparture = "shuttleSessionDeparture"
        case shuttleSessionReturn = "shuttleSessionReturn"
    }
}

struct ShuttleSessionDeparture: Codable {
    let id, companyID, busID, passengerCount: Int?
    let startTime: String?
    let driverID: Int?
    let isActive: Bool?
    let longitude, latitude, destinationName: String?
    let shuttleSessionDepartureReturn: Bool?
    let sessionDate: String?
    let capacity: Int?
    let busModel, licensePlate: String?
    let state: Bool?


    enum CodingKeys: String, CodingKey {
        case id = "id"
        case companyID = "companyId"
        case busID = "busId"
        case passengerCount = "passengerCount"
        case startTime = "startTime"
        case driverID = "driverId"
        case isActive = "isActive"
        case longitude = "longitude"
        case latitude = "latitude"
        case destinationName = "destinationName"
        case shuttleSessionDepartureReturn = "return"
        case sessionDate = "sessionDate"
        case capacity = "capacity"
        case busModel = "busModel"
        case licensePlate = "licensePlate"
        case state = "state"
    }
}
