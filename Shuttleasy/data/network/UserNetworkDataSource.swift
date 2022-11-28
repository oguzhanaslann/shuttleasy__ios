//
//  UserNetworkDataSource.swift
//  Shuttleasy
//
//  Created by Oğuzhan Aslan on 20.11.2022.
//

import Foundation

struct UserAuthDTO {
    let id : String
    let authenticationToken : String
    let profileType : ProfileType
}

protocol  UserNetworkDataSource {
    func signInUser(email: String , password: String) async throws -> UserAuthDTO
    func signUpUser(email: String , password: String) async throws -> UserAuthDTO
    func sendResetCodeTo(email: String) async throws -> Bool
}

class UserNetworkDataSourceImpl : UserNetworkDataSource {
    func signInUser(email: String, password: String) async throws -> UserAuthDTO {
        // TODO: Implement this method with real network call
        print("UserNetworkDataSourceImpl - signInUser - email: \(email) - password: \(password)")
        return UserAuthDTO(
            id : "123",
            authenticationToken: "123",
            profileType: .driver
        )
    }

    func signUpUser(email: String, password: String) async throws -> UserAuthDTO {
        print("UserNetworkDataSourceImpl - signUpUser - email: \(email) - password: \(password)")
        return UserAuthDTO(
            id : "123",
            authenticationToken: "123",
            profileType: .driver
        )
    }

    func sendResetCodeTo(email: String) async throws -> Bool {
        print("UserNetworkDataSourceImpl - sendResetCodeTo - email: \(email)")
        return true
    }
}
