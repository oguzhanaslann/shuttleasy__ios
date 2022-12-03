//
//  UserNetworkDataSource.swift
//  Shuttleasy
//
//  Created by Oğuzhan Aslan on 20.11.2022.
//

import Foundation

protocol  UserNetworkDataSource {
    func signInUser(email: String , password: String) async throws -> UserAuthDTO
    func signUpUser(email: String , password: String) async throws -> UserAuthDTO
    func sendResetCodeTo(email: String) async throws -> Bool
    func sendResetCode(code: String, email : String) async throws -> String
    func resetPassword(password: String, passwordAgain: String) async throws -> Bool
    func getUserProfile() async throws -> UserProfileDTO
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

    func sendResetCode(code: String, email: String) async throws -> String {
        print("UserNetworkDataSourceImpl - sendResetCode - code: \(code)")
        return "some token"
    }

    func resetPassword(password: String, passwordAgain: String) async throws -> Bool {
        print("UserNetworkDataSourceImpl - resetPassword - password: \(password)")
        return true
    }

    func getUserProfile() async throws -> UserProfileDTO {
        print("UserNetworkDataSourceImpl - getUserProfile")
        return UserProfileDTO(
            profileType : .passenger,
            profileImageUrl : "https://cdn.pixabay.com/photo/2017/02/20/18/03/cat-2083492_960_720.jpg",
            profileName : "Oğuzhan Aslan",
            profileEmail : "sample@sample.com",
            profilePhone : "+905554443322",
            qrSeed : "1234567890"
        )       
    }
}
