//
//  Authenticator.swift
//  Shuttleasy
//
//  Created by Oğuzhan Aslan on 20.11.2022.
//

import Foundation

protocol Authenticator {
    func signInUser(email : String, password: String, isDriver : Bool) async -> Result<Bool,Error>
    func signUpUser(
        email : String,
        password: String,
        name :String,
        surname: String,
        phone : String
    ) async -> Result<Bool,Error>
    func sendResetCodeTo(email : String) async ->  Result<Bool,Error>
    func sendResetCode(code : String,email : String) async  ->  Result<Bool,Error>
    func resetPassword(password : String, passwordAgain: String) async throws -> Bool
    
}
