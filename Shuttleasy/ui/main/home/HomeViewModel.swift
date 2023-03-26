//
//  HomeViewModel.swift
//  Shuttleasy
//
//  Created by OguzhanMac on 26.03.2023.
//

import Foundation
import Combine
 
class HomeViewModel : ViewModel {
    
    private let userRepository: UserRepository
    
    private let userProfileSubject : CurrentValueSubject<UiDataState<UserProfile>, Error> = CurrentValueSubject(UiDataState.getDefaultCase())
    let userProfilePublisher : AnyPublisher<UiDataState<UserProfile>, Error>
     
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
        self.userProfilePublisher = userProfileSubject.eraseToAnyPublisher()  
    } 


    func getUserProfile() {
        Task.init {
            let result = await self.userRepository.getUserProfile()
            userProfileSubject.send(result.toUiDataState())
        }
    }
}
