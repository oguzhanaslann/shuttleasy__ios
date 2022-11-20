//
//  NetworkMapperExtensions.swift
//  Shuttleasy
//
//  Created by Oğuzhan Aslan on 20.11.2022.
//

import Foundation


extension UserAuthDTO {
    //UserAuthenticationModel
    func toUserAuthenticationModel() -> UserAuthenticationModel {
        return UserAuthenticationModel(
            id: self.id,
            authenticationToken: self.authenticationToken,
            profileType: self.profileType
        )
    }
}
