//
//  SessionDetailViewModel.swift
//  Shuttleasy
//
//  Created by OguzhanMac on 24.04.2023.
//

import Foundation
import Combine

class SessionDetailViewModel: ViewModel {

    private let sessionDetailSubject = CurrentValueSubject<UiDataState<SessionDetailWithState>, Error>(UiDataState.Initial)  
    let sessionDetailPublisher : AnyPublisher<UiDataState<SessionDetailWithState>, Error>

    init() {
        sessionDetailPublisher = sessionDetailSubject.eraseToAnyPublisher()
    }

    public func getSessionDetail(sessionId : Int) {
        Task.init {
            sessionDetailSubject.send(.Loading)
            sessionDetailSubject.send(
                .Success(
                    .createFrom(
                        data: SessionDetailWithState(
                            sessionDetail: SessionDetail(
                                vehiclePlateNumber: "35YU3637",
                                destinationName: "Yaşar Üniversitesi",
                                startTime: .now),
                            sessionState: .ongoing
                        )
                    )
                )
            )
        }
    }

}
