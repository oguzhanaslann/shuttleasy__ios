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

    private let userInfoRepository: UserInfoRepository
    
    init(
        userInfoRepository : UserInfoRepository
    ) {
        publisher = subject.eraseToAnyPublisher()
        self.userInfoRepository  = userInfoRepository
    }
    

    func getUserProfile() {
        subject.send(UiDataState.Loading)
        Task.init {
            do {
                let userProfile = try await userInfoRepository.getUserProfile()
                subject.send(UiDataState.Success(
                    DataContent.createFrom(data: userProfile)
                ))
            } catch {
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
