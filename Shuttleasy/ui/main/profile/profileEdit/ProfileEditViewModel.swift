//
//  ProfileEditViewModel.swift
//  Shuttleasy
//
//  Created by Oğuzhan Aslan on 4.12.2022.
//

import Foundation
import Combine

enum EditState {
    case proccessing
    case success
    case error
}

class ProfileEditViewModel {

    private let userProfileSubject : CurrentValueSubject<UiDataState<UserProfile>, Error> = CurrentValueSubject(UiDataState.getDefaultCase())
    let userProfilePublisher : AnyPublisher<UiDataState<UserProfile>, Error>
    
    private let editProfileSubject = PassthroughSubject<EditState,Never>()
    let editProfilePublisher : AnyPublisher<EditState,Never>
    
    
    private let userInfoRepository: UserRepository
    
    private var task : Task<(), Error>? = nil

    init(
        userInfoRepository : UserRepository
    ) {
        userProfilePublisher = userProfileSubject.eraseToAnyPublisher()
        editProfilePublisher = editProfileSubject.eraseToAnyPublisher()
        self.userInfoRepository  = userInfoRepository
    }
    
    func setUserProfile(userProfile: UserProfile) {
        userProfileSubject.send(UiDataState.Success(
            DataContent.createFrom(data: userProfile)
        ))
    } 


    func getUserProfile(onlyWhenNeeded: Bool = true) {
        if onlyWhenNeeded && userProfileSubject.value.isSuccess() { return }
        
        userProfileSubject.send(UiDataState.Loading)
        Task.init {
            let userProfile =  await userInfoRepository.getUserProfile()
            
            switch userProfile  {
                case (.success(let userProfile) ):
                    userProfileSubject.send(
                        UiDataState.Success(
                            DataContent.createFrom(data: userProfile)
                        )
                    )
                case .failure(let error):
                    userProfileSubject.send(completion: .failure(error))
            }
        }
    }

    func editProfile(
        profilePhotoData: Data?,
        name: String,
        surname: String,
        email: String,
        phone: String
    ) {
        if task?.isCancelled.not() ?? false { 
            editProfileSubject.send(.proccessing)
            return 
        }
        
        if (profilePhotoData == nil) {
            print("profile data nil")
            editProfileSubject.send(.error)
            return
        }

        task =  Task.init {
            let result = await userInfoRepository.editProfile(
              profileEdit: ProfileEdit(
                  name: name,
                  surname: surname,
                  email: email,
                  phoneNumber: phone,
                  profileImage: profilePhotoData!
              )
            )

            switch result {
                case .success(let userProfile):
                    userProfileSubject.send(
                        UiDataState.Success(
                            DataContent.createFrom(data: userProfile)
                        )
                    )
                    editProfileSubject.send(.success)
                case .failure(let error):
                    print("Error while editing profile \(error.localizedDescription)")
                    editProfileSubject.send(.error)
            }
        }
    }    
}
