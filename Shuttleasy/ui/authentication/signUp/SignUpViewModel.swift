//
//  SignUpViewModel.swift
//  Shuttleasy
//
//  Created by Oğuzhan Aslan on 27.11.2022.
//

import Foundation
import Combine

class SignUpViewModel : ViewModel {

     let authenticator : Authenticator

    let signUpResult = PassthroughSubject<Bool, Error>()

    init( authenticatior : Authenticator) {
        self.authenticator = authenticatior
    }
    
    func signInUser(email: String , password: String) {
        Task.init {
            do {
               let result = try await self.authenticator.signUpUser(email: email, password: password)
                self.signUpResult.send(result)
            } catch {
                self.signUpResult.send(completion: .failure(error))
            }
        }
    }
    
}
