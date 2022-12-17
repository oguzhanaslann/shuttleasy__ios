//
//  EmailPasswordResetViewModel.swift
//  Shuttleasy
//
//  Created by Oğuzhan Aslan on 28.11.2022.
//

import Foundation
import Combine

class EmailPasswordResetViewModel : ViewModel {

     let authenticator : Authenticator

    private let subject = PassthroughSubject<UiDataState<Bool>, Error>()
    let emailResetResult : AnyPublisher<UiDataState<Bool>, Error>

    init( authenticatior : Authenticator) {
        self.authenticator = authenticatior
        self.emailResetResult = subject.eraseToAnyPublisher()
    }
    
    func sendResetCodeTo(email : String) {
        Task.init {
            let result = try await self.authenticator.sendResetCodeTo(email: email)

            switch result {
                case .success(let isSuccess):
                    debugPrint("EmailPasswordResetViewModel - signInUser - isSuccess: \(isSuccess)")
                    subject.send(UiDataState.Success(DataContent.createFrom(data: isSuccess)))
                case .failure(let error):
                    debugPrint("EmailPasswordResetViewModel - signInUser - error: \(error) - message : \(error.localizedDescription)")
                    subject.send(UiDataState.Error(error.localizedDescription))
            }
            
        }
    }
    
}
