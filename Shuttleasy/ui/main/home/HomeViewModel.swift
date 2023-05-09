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
     
    private let activeSessionsSubject : CurrentValueSubject<UiDataState<[ActiveSession]>, Error> = CurrentValueSubject(UiDataState.getDefaultCase())
    let activeSessionsPublisher : AnyPublisher<UiDataState<[ActiveSession]>, Error>
    
    let nextSessionPublisher : AnyPublisher<ActiveSession, Error>
    let upComingSessionsPublisher : AnyPublisher<[ActiveSession], Error>
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
        self.userProfilePublisher = userProfileSubject.eraseToAnyPublisher()  
        self.activeSessionsPublisher = activeSessionsSubject.eraseToAnyPublisher()
        
         self.nextSessionPublisher = activeSessionsPublisher
            .map { $0.getDataContent()?.data }
            .filter { $0 != nil }
            .map {  $0!.sorted(by: { $0.startDate < $1.startDate }).first }
            .filter { $0 != nil }
            .map { $0! }
            .eraseToAnyPublisher()


        // upcoming sessions are ActiveSessions that are not next session, so filter the next session from active sessions 
        self.upComingSessionsPublisher = activeSessionsPublisher
            .map { $0.getDataContent()?.data }
            .filter { $0 != nil }
            .map {  $0!.sorted(by: { $0.startDate < $1.startDate })}
            .map { $0.dropFirst() }
            .map { Array($0) }
            .eraseToAnyPublisher()
    } 

    func getUserProfile() {
        Task.init {
            userProfileSubject.send(.Loading)
            let result = await self.userRepository.getUserProfile()
            userProfileSubject.send(result.toUiDataState())
        }
    }

    func getActiveSessions() {
        Task.init {
            activeSessionsSubject.send(.Loading)
            let result = await self.userRepository.getActiveSessions()
            activeSessionsSubject.send(result.toUiDataState())
        }
    }

    
    func getCurrentProfile() -> UserProfile? {
        return userProfileSubject.value.getDataContent()?.data
    }
}
