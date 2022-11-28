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

    let emailResetResult = PassthroughSubject<Bool, Error>()

    init( authenticatior : Authenticator) {
        self.authenticator = authenticatior
    }
    
    func sendResetCodeTo(email : String) {
        Task.init {
            do {
               let result = try await self.authenticator.sendResetCodeTo(email: email)
                self.emailResetResult.send(result)
            } catch {
                self.emailResetResult.send(completion: .failure(error))
            }
        }
    }
    
}
