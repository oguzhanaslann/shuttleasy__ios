//
//  ActiveSessionDTO.swift
//  Shuttleasy
//
//  Created by OguzhanMac on 28.03.2023.
//

import Foundation

/*
{
  "id": 33,
  "companyId": 1,
  "busId": 15,
  "passengerCount": 3,
  "startTime": "2023-04-03T09:00:10.74",
  "driverId": 61,
  "isActive": true,
  "longitudeStart": "27.105736",
  "latitudeStart": "38.40222",
  "startName": "Hatay Polis Merkezi",
  "longitudeFinal": "27.1816175",
  "latitudeFinal": "38.4457575",
  "destinationName": "Yaşar Üniversitesi",
  "return": false,
  "sessionDate": "Monday",
  "capacity": 15,
  "busModel": "Opel",
  "licensePlate": "35SE032",
  "state": true
}
]
*/

typealias ActiveSessionDTO = [ActiveSessionDTOElement]

// codable 
struct ActiveSessionDTOElement : Codable {
    let id : Int?
    let companyId : Int?
    let busId : Int?
    let passengerCount : Int?
    let startTime : String?
    let driverId : Int?
    let isActive : Bool?
    let longitudeStart : String?
    let latitudeStart : String?
    let startName : String?
    let longitudeFinal : String?
    let latitudeFinal : String?
    let destinationName : String? 
    let isReturn : Bool?
    let sessionDate : String?
    let capacity : Int?
    let busModel : String?
    let licensePlate : String?
    let state : Bool?


    enum CodingKeys: String, CodingKey {
        case id = "id"
        case companyId = "companyId"
        case busId = "busId"
        case passengerCount = "passengerCount"
        case startTime = "startTime"
        case driverId = "driverId"
        case isActive = "isActive"
        case longitudeStart = "longitudeStart"
        case latitudeStart = "latitudeStart"
        case startName = "startName"
        case longitudeFinal = "longitudeFinal"
        case latitudeFinal = "latitudeFinal"
        case destinationName = "destinationName"
        case isReturn = "return"
        case sessionDate = "sessionDate"
        case capacity = "capacity"
        case busModel = "busModel"
        case licensePlate = "licensePlate"
        case state = "state"
    }

}
