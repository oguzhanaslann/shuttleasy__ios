//
//  DeleteAccountViewModel.swift
//  Shuttleasy
//
//  Created by Oğuzhan Aslan on 10.12.2022.
//

import Foundation
import Combine

class DeleteAccountViewModel {
        
    private let deleteAccountResult = PassthroughSubject<Bool, Error>()
    let deleteAccountPublisher : AnyPublisher<Bool, Error>
    private let userRepository : UserRepository

    init(userRepository: UserRepository) {
        self.userRepository = userRepository
        self.deleteAccountPublisher = deleteAccountResult.eraseToAnyPublisher()
    }
        
    func deleteAccount(email: String, password: String) {
        Task.init {
            let result = try await self.userRepository.deleteAccount(email: email, password: password)
            switch result  {
                case (.success(let isSuccess) ):
                    deleteAccountResult.send(isSuccess)
                case .failure(let error):
                    deleteAccountResult.send(completion: .failure(error))
            }
        }
    }
}
