//
//  UserAuthDTO.swift
//  Shuttleasy
//
//  Created by Oğuzhan Aslan on 3.12.2022.
//

import Foundation

struct UserAuthDTO {
    let id : Int
    let authenticationToken : String
    let profileType : ProfileType
    let profilePic:  String
    let name: String
    let surname: String
    let phoneNumber: String
    let qrString: String
    let email:String
}
