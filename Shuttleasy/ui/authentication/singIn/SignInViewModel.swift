//
//  SignInViewModel.swift
//  Shuttleasy
//
//  Created by Oğuzhan Aslan on 17.11.2022.
//

import Foundation
import Combine

protocol Authenticator {
    func signInUser(email : String, password: String) async throws -> Bool
}

class AuthenticatorImpl : Authenticator {

    let userInfoLocalDataSource : UserInfoLocalDataSource

    init(userInfoLocalDataSource : UserInfoLocalDataSource) {
        self.userInfoLocalDataSource = userInfoLocalDataSource
    }

    func signInUser(email: String, password: String) async throws -> Bool {
        await userInfoLocalDataSource.setAsLoggedIn()
        return true
    }
}

class SignInViewModel : ViewModel {
    
    let authenticator : Authenticator

    let signInResult = PassthroughSubject<Bool, Error>()

    init( authenticatior : Authenticator) {
        self.authenticator = authenticatior
    }
    
    func signInUser(email: String , password: String) {
        Task.init {
            do {
               let result = try await self.authenticator.signInUser(email: email, password: password)
                self.signInResult.send(result)
            } catch {
                self.signInResult.send(completion: .failure(error))
            }
        }
    }
}
