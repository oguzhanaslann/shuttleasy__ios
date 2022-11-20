//
//  SignInViewModel.swift
//  Shuttleasy
//
//  Created by Oğuzhan Aslan on 17.11.2022.
//

import Foundation
import Combine


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
