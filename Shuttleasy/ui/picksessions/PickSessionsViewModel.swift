//
//  PickSessionsViewModel.swift
//  Shuttleasy
//
//  Created by OguzhanMac on 25.03.2023.
//

import Foundation
import Combine

fileprivate typealias SessionPickOptions = [SessionPickListModel]

class PickSessionsViewModel : ViewModel {
    
    private let sessionModelListSubject : CurrentValueSubject<Pair<SessionPickOptions,Int?>, Never> = CurrentValueSubject(.init(first: [], second: nil))
    let sessionModelListPublisher : AnyPublisher<Pair<[SessionPickListModel],Int?>, Never>
        
    let selectedSessionsPublisher : AnyPublisher<[SessionPickModel], Never>
    
    init() {
        self.sessionModelListPublisher = sessionModelListSubject.eraseToAnyPublisher()
        
        selectedSessionsPublisher = sessionModelListSubject
            .map { $0.first }
            .map { $0.flatMap { $0.sessionPickList } }
            .map { $0.filter { $0.isSelected } }
            .eraseToAnyPublisher()
    }
    
    func setSessionModels(_ models : [SessionPickListModel]) {
        sessionModelListSubject.send(
            .init(first: models, second: nil)
        )
    }
    
    func onSessionToggleReceive(pickModelIndex: Int, sessionIndex: Int) {
        let currentList = sessionModelListSubject.value.first
        var newList = currentList
        let sessionList = newList[pickModelIndex]
        let toggleReceivedItem = sessionList.sessionPickList[sessionIndex]
        
        guard toggleReceivedItem.isEnabled else { return }
        
        let newPickList = sessionList.sessionPickList.map { model in
            if model.sessionId == toggleReceivedItem.sessionId {
                return SessionPickModel(
                    sessionId: model.sessionId,
                    isSelected: !model.isSelected,
                    isEnabled: model.isEnabled,
                    sessionTitle: model.sessionTitle
                )
            } else {
                return model
            }
        }

        newList[pickModelIndex] = SessionPickListModel(
            dayName: sessionList.dayName,
            sessionPickList: newPickList
        )
        
        sessionModelListSubject.send(
            .init(first: newList, second: pickModelIndex)
        )
    }

    func getSelectedSessionIds() -> [Int] {
        return sessionModelListSubject.value
            .first
            .compactMap { $0.sessionPickList }
            .flatMap { $0 }
            .filter({ $0.isSelected })
            .map { $0.sessionId }
    }
}
