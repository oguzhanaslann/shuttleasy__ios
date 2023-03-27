//
//  PickupSelectionViewModel.swift
//  Shuttleasy
//
//  Created by OguzhanMac on 19.03.2023.
//

import Foundation
import Combine

struct EnrollResult{
    let enrolledSessionIds: [Int]
    let pickUpPoint : CGPoint
}

class PickupSelectionViewModel : ViewModel {
    
    private let companyRepository : CompanyRepository
    
    private let pickupAreaSubject = CurrentValueSubject<UiDataState<[PickupArea]>, Error>(UiDataState.Initial)
    let pickupAreaPublished : AnyPublisher<UiDataState<[PickupArea]>, Error>

    private let enrollEventSubject = PassthroughSubject<UiDataState<EnrollResult>, Error>()
    let enrollEventPublished : AnyPublisher<UiDataState<EnrollResult>, Error>
    
    init(companyRepository: CompanyRepository) {
        self.companyRepository = companyRepository
        self.pickupAreaPublished = pickupAreaSubject.eraseToAnyPublisher()       
        self.enrollEventPublished = enrollEventSubject.eraseToAnyPublisher()
    }
    
    func getPickupAreasOf(
        destinationPoint: CGPoint,
        sessionPickModel : [SessionPickListModel]
    ) {
        print("getPickupAreasOf : \(destinationPoint)")
        Task.init {
            
            let sessionIds = sessionPickModel
                .flatMap {
                    $0.sessionPickList.map{ $0.sessionId }
                }
            
            let result = await self.companyRepository.getCompanyPickupAreas(
                destinationPoint: destinationPoint,
                sessionIds: sessionIds
            )
            
            pickupAreaSubject.send(result.toUiDataState())
        }
    }
    
    func getCurrentPickupAreas() -> [PickupArea]? {
        return pickupAreaSubject.value.getDataContent()?.data
    }
    
    
    func enrollUserToCompanySessions(
        pickUpPoint: CGPoint
    ) {
        Task.init {
            
            enrollEventSubject.send(.Loading)
            
            var sessionIds:  [Int] = []
            
            let currentAreas = getCurrentPickupAreas() ?? []
            
            for area in currentAreas {
                if pickUpPoint.isInside(area.polygon) {
                    sessionIds.append(area.sessionId)
                }
            }
            
           
            let enrolledSessionResult: Result<EnrollResult, Never>  = Result.success(
                EnrollResult(
                    enrolledSessionIds: sessionIds,
                    pickUpPoint: pickUpPoint
                )
            )
            
            enrollEventSubject.send(enrolledSessionResult.toUiDataState())
        }
    }
}


