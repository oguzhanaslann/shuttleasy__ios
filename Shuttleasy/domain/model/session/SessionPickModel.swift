//
//  SessionPickModel.swift
//  Shuttleasy
//
//  Created by OguzhanMac on 25.03.2023.
//

import Foundation


struct SessionPickModel {
    let sessionId : Int
    var isSelected: Bool
    let isEnabled : Bool
    let sessionTitle: String
    var sessionDate: String = ""
}
