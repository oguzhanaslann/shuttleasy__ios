//
//  ActiveSession.swift
//  Shuttleasy
//
//  Created by OguzhanMac on 28.03.2023.
//

import Foundation

struct ActiveSession {
    let sessionId : Int
    let plateNumber : String
    let destinationName : String
    let startDate: Date
    let startLocation : CGPoint
    let endLocation : CGPoint
    let isReturn : Bool
    var totalPassengers: Int? = nil
    var passengerCapacity : Int? = nil
}
