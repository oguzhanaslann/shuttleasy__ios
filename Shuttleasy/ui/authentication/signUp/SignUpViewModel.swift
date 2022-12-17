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

    let signUpResult = PassthroughSubject<UiDataState<Bool>, Error>()
    let resultPublisher : AnyPublisher<UiDataState<Bool>, Error>

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

            let result = try await self.authenticator.signUpUser(
                email: email,
                password: password,
                name: name,
                surname: surname,
                phone: phone
            )
                        
            switch result {
                case .success(let isSuccess):
                    print("SignInViewModel - signInUser - isSuccess: \(isSuccess)")
                    signUpResult.send(UiDataState.Success(DataContent.createFrom(data: isSuccess)))
                case .failure(let error):
                    print("SignInViewModel - signInUser - error: \(error) - message : \(error.localizedDescription)")
                    signUpResult.send(UiDataState.Error(error.localizedDescription))
                }
        }
    }    
}
