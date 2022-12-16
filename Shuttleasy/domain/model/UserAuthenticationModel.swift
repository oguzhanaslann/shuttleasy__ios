//
//  UserAuthenticationModel.swift
//  Shuttleasy
//
//  Created by Oğuzhan Aslan on 20.11.2022.
//

import Foundation

struct UserAuthenticationModel {
    let id : Int
    let authenticationToken : String
    let profilePic: String
    let name: String
    let surname: String
    let phoneNumber: String
    let qrString: String
    let email: String
    let profileType : ProfileType
} 
