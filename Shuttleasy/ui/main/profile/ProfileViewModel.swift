//
//  ProfileViewModel.swift
//  Shuttleasy
//
//  Created by Oğuzhan Aslan on 3.12.2022.
//

import Foundation
import Combine

class ProfileViewModel: ViewModel {
    
    private let subject = CurrentValueSubject<UiDataState<UserProfile>, Error>(UiDataState.getDefaultCase())
    let publisher: AnyPublisher<UiDataState<UserProfile>, Error>

    private let userLogoutResultSubject = PassthroughSubject<UiDataState<Void>, Error>()
    let userLogoutResultPublisher: AnyPublisher<UiDataState<Void>, Error>

    private let userRepository: UserRepository
    
    init(
        userRepository : UserRepository
    ) {
        publisher = subject.eraseToAnyPublisher()
        userLogoutResultPublisher = userLogoutResultSubject.eraseToAnyPublisher()
        self.userRepository  = userRepository
    }
    
    func getUserProfile() {
        subject.send(UiDataState.Loading)
        Task.init {
            let userProfile =  await userRepository.getUserProfile()
            
            switch userProfile  {
                case (.success(let userProfile) ):
                    subject.send(
                        UiDataState.Success(
                            DataContent.createFrom(data: userProfile)
                        )
                    )
                case .failure(let error):
                    subject.send(UiDataState.Error(error.localizedDescription))
            }
        }
    }

    func getQrSeedOrEmpty() -> String {
        let data = subject.value.getDataContent()?.data
        
        let isPassengerData = data?.profileType == .passenger
        
        if isPassengerData {
            return data?.qrSeed ?? ""
        } else {
            return ""
        }
    }

    func getUserRole() -> ProfileType {
        let data = subject.value.getDataContent()?.data
        return data?.profileType ?? .passenger
    }

    func logOut() {
        Task.init {
            let result = await userRepository.logOut()
            switch result {
                case .success(_):
                userLogoutResultSubject.send(UiDataState.Success(DataContent.createFrom(data: ())))
                case .failure(let error):
                userLogoutResultSubject.send(UiDataState.Error(error.localizedDescription))
            }
        }
    }

    //updateDarkModePreference
    func updateDarkModePreference(isDarkMode: Bool) {
        Task.init {
            let result = await userRepository.updateDarkModePreference(isDarkMode: isDarkMode)
            switch result {
                case .success(_):
                    print("Dark mode preference updated")
                case .failure(let error):
                    print("Dark mode preference update failed")
            }
        }
    }
}
