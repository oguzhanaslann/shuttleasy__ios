//
//  DeleteAccountViewModel.swift
//  Shuttleasy
//
//  Created by Oğuzhan Aslan on 10.12.2022.
//

import Foundation
import Combine

class DeleteAccountViewModel {
        
    private let deleteAccountResult = PassthroughSubject<UiDataState<Bool>, Error>()
    let deleteAccountPublisher : AnyPublisher<UiDataState<Bool>, Error>
    private let userRepository : UserRepository

    init(userRepository: UserRepository) {
        self.userRepository = userRepository
        self.deleteAccountPublisher = deleteAccountResult.eraseToAnyPublisher()
    }
        
    func deleteAccount(email: String, password: String) {
        deleteAccountResult.send(UiDataState.Loading)
        Task.init {
            let result = try await self.userRepository.deleteAccount(email: email, password: password)
            switch result  {
                case (.success(let isSuccess) ):
                    deleteAccountResult.send(UiDataState.Success(DataContent.createFrom(data: isSuccess)))
                case .failure(let error):
                    print("DeleteAccountViewModel - deleteAccount - error: \(error) - message : \(error.localizedDescription)")
                    deleteAccountResult.send(UiDataState.Error(error.localizedDescription))
            }
        }
    }
}
