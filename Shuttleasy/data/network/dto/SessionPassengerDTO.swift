//
//  SessionPassengerDTO.swift
//  Shuttleasy
//
//  Created by OguzhanMac on 10.05.2023.
//

import Foundation

struct SessionPassengerDTO: Codable {
    let profilePic, name, surname, phoneNumber: String?
    let email, city, passengerAddress: String?
    
    enum CodingKeys: String, CodingKey {
         case profilePic = "profilePic"
         case name = "name"
         case surname = "surname"
         case phoneNumber = "phoneNumber"
         case email = "email"
         case city = "city"
         case passengerAddress = "passengerAddress"
     }
}

typealias SessionPassengersDTO = [SessionPassengerDTO]
