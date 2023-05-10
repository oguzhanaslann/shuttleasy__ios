//
//  DriverSessionDetailViewModel.swift
//  Shuttleasy
//
//  Created by OguzhanMac on 9.05.2023.
//

import Foundation
import Combine

class DriverSessionDetailViewModel: ViewModel {
    
    private let sessionRepository: SessionRepository
    
    private let driverSessionDetail : CurrentValueSubject<UiDataState<DriverSessionDetail>, Error> = CurrentValueSubject(UiDataState.getDefaultCase())
    let driverSessionDetailPublisher : AnyPublisher<UiDataState<DriverSessionDetail>, Error>

    init(sessionRepository: SessionRepository) {
        self.sessionRepository = sessionRepository
        self.driverSessionDetailPublisher = driverSessionDetail.eraseToAnyPublisher()
    }
    
    func getDetail(sessionId : Int) {
        Task.init {
            driverSessionDetail.send(.Loading)
            let driverSessionDetailResult = await sessionRepository.getDriverSessionDetail(sessionId: sessionId)
            driverSessionDetail.send(driverSessionDetailResult.toUiDataState())
        }
    }
}


struct DriverSessionDetail {
    let id : Int
    let passengers : [SessionPassenger]
}
