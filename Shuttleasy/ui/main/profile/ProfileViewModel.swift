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

    private let userInfoRepository: UserRepository
    
    init(
        userInfoRepository : UserRepository
    ) {
        publisher = subject.eraseToAnyPublisher()
        self.userInfoRepository  = userInfoRepository
    }
    
    func getUserProfile() {
        subject.send(UiDataState.Loading)
        Task.init {
            let userProfile =  await userInfoRepository.getUserProfile()
            
            switch userProfile  {
                case (.success(let userProfile) ):
                    subject.send(
                        UiDataState.Success(
                            DataContent.createFrom(data: userProfile)
                        )
                    )
                case .failure(let error):
                    subject.send(completion: .failure(error))
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
}
