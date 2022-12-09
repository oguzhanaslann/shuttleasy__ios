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
    let resultPublisher : AnyPublisher<Bool, Error>

    init( authenticatior : Authenticator) {
        self.authenticator = authenticatior
        self.resultPublisher = signUpResult.eraseToAnyPublisher()
    }
    
    func signUpUser(
        email: String,
        password: String,
        name :String,
        surname: String,
        phone : String
    ) {
        Task.init {
            do {
               let result = try await self.authenticator.signUpUser(
                    email: email,
                    password: password,
                    name: name,
                    surname: surname,
                    phone: phone
                )
                self.signUpResult.send(result)
            } catch {
                self.signUpResult.send(completion: .failure(error))
            }
        }
    }    
}
