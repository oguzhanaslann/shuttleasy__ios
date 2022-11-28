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
   
    let resetPasswordResult = PassthroughSubject<Bool, Error>()
    
    init(authenticatior : Authenticator) {
        self.authenticator = authenticatior
    }

    func resetPasswordOfUser(password: String, passwordAgain: String) {
        Task.init {
            do {
                print("resetPasswordOfUser")
                let result = try await self.authenticator.resetPassword(password: password, passwordAgain: passwordAgain)
                self.resetPasswordResult.send(result)
            } catch {
               self.resetPasswordResult.send(completion: .failure(error))
            }
        }
    }
}
