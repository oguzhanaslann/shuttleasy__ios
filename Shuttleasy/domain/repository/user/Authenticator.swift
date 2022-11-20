//
//  Authenticator.swift
//  Shuttleasy
//
//  Created by Oğuzhan Aslan on 20.11.2022.
//

import Foundation

protocol Authenticator {
    func signInUser(email : String, password: String) async throws -> Bool
}
