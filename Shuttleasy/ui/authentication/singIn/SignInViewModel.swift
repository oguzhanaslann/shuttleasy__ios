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

    private let subject = PassthroughSubject<UiDataState<Bool>, Error>()
    let signInResult : AnyPublisher<UiDataState<Bool>, Error>

    init( authenticatior : Authenticator) {
        self.authenticator = authenticatior
        self.signInResult = subject.eraseToAnyPublisher()
    }
    
    func signInUser(email: String , password: String, isDriver: Bool = false) {
        Task.init {
            let result = try await self.authenticator.signInUser(
                email: email,
                password: password,
                isDriver: isDriver
            )

            switch result {
                case .success(let isSuccess):
                    print("SignInViewModel - signInUser - isSuccess: \(isSuccess)")
                    subject.send(UiDataState.Success(DataContent.createFrom(data: isSuccess)))

                case .failure(let error):
                    print("SignInViewModel - signInUser - error: \(error) - message : \(error.localizedDescription)")
                    subject.send(UiDataState.Error(error.localizedDescription))
            }
        }
    }
}
