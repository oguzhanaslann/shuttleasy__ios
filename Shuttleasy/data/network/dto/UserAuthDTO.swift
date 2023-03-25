//
//  UserAuthDTO.swift
//  Shuttleasy
//
//  Created by Oğuzhan Aslan on 3.12.2022.
//

import Foundation

/**
 
 {
   "id": 81,
   "profilePic": "",
   "name": "Og",
   "surname": "As",
   "phoneNumber": "5398775750",
   "email": "oguzhan.aslan@gmail.com",
   "city": null,
   "passengerAddress": null,
   "qrString": "1d435b59-7183-44b1-a322-77591a2dd164",
   "token": "eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJodHRwOi8vc2NoZW1hcy5taWNyb3NvZnQuY29tL3dzLzIwMDgvMDYvaWRlbnRpdHkvY2xhaW1zL3JvbGUiOiJwYXNzZW5nZXIiLCJpZCI6IjgxIiwicm9sZSI6InBhc3NlbmdlciIsImV4cCI6MTcwMzUwMzM3Mn0.HfqhkB7mFSpBAbiAcfWW2w62bAbVNeXWnlh_hIzboyXV3SVr1zWyfVKGir_NSZa9l77GOoA5dcOfwn6NA1cayQ"
 }
 
 */


struct UserAuthDTO : Codable {
    let id : Int
    let profilePic : String
    let name : String
    let surname : String
    let phoneNumber : String
    let email : String
    let city : String?
    let passengerAddress : String?
    let qrString : String
    let token : String

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case profilePic = "profilePic"
        case name = "name"
        case surname = "surname"
        case phoneNumber = "phoneNumber"
        case email = "email"
        case city = "city"
        case passengerAddress = "passengerAddress"
        case qrString = "qrString"
        case token = "token"
    }
}
