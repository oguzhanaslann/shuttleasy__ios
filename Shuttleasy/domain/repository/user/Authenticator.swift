//
//  Authenticator.swift
//  Shuttleasy
//
//  Created by Oğuzhan Aslan on 20.11.2022.
//

import Foundation

protocol Authenticator {
    func signInUser(email : String, password: String) async throws -> Bool
    func signUpUser(
        email : String,
        password: String,
        name :String,
        surname: String,
        phone : String
    ) async throws -> Bool
    func sendResetCodeTo(email : String) async throws -> Bool
    func sendResetCode(code : String,email : String) async throws -> Bool
    func resetPassword(password : String, passwordAgain: String) async throws -> Bool
    
}
