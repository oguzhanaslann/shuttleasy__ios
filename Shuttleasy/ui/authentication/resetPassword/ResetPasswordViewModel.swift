//
//  ResetPasswordViewModel.swift
//  Shuttleasy
//
//  Created by Oğuzhan Aslan on 28.11.2022.
//

import Foundation
import Combine

class ResetPasswordViewModel: ViewModel {
    
    let authenticator : Authenticator
   
    private let subject = PassthroughSubject<UiDataState<Bool>, Error>()
    let resetPasswordResult: AnyPublisher<UiDataState<Bool>, Error>
    
    init(authenticatior : Authenticator) {
        self.authenticator = authenticatior
        self.resetPasswordResult = subject.eraseToAnyPublisher()
    }

    func resetPasswordOfUser(email:String, password: String) {
        Task.init {
            let result = try await self.authenticator.resetPassword(email: email, password: password)

            switch result {
            case .success(let success):
                self.subject.send(UiDataState.Success(DataContent.createFrom(data: success)))
            case .failure(let error):
                self.subject.send(UiDataState.Error(error.localizedDescription))
            }
        }
    }
}
