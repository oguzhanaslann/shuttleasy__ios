//
//  MainVewModel.swift
//  Shuttleasy
//
//  Created by OguzhanMac on 8.02.2023.
//

import Foundation
import Combine

class MainViewModel : ViewModel {
    
    private let currentValueSubject = CurrentValueSubject<ProfileType, Never>(ProfileType.passenger)
    let profileType : AnyPublisher<ProfileType,Never>

    private let userRepository: UserRepository
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
        self.profileType = currentValueSubject.eraseToAnyPublisher()
    }

    func getProfileType() {
        Task.init {
            let type = await userRepository.getUserProfileType()
            currentValueSubject.send(type)
        }
    }
    
    func currentProfileType() -> ProfileType {
        return currentValueSubject.value
    }

}
