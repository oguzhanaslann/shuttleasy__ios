//
//  PickupSelectionViewModel.swift
//  Shuttleasy
//
//  Created by OguzhanMac on 19.03.2023.
//

import Foundation
import Combine

class PickupSelectionViewModel : ViewModel {
    
    private let companyRepository : CompanyRepository
    
    private let pickupAreaSubject = CurrentValueSubject<UiDataState<PickupAreas>, Error>(UiDataState.Initial)
    let pickupAreaPublished : AnyPublisher<UiDataState<PickupAreas>, Error>

    private let enrollEventSubject = PassthroughSubject<UiDataState<Void>, Error>()
    let enrollEventPublished : AnyPublisher<UiDataState<Void>, Error>
    
    init(companyRepository: CompanyRepository) {
        self.companyRepository = companyRepository
        self.pickupAreaPublished = pickupAreaSubject.eraseToAnyPublisher()       
        self.enrollEventPublished = enrollEventSubject.eraseToAnyPublisher()
    }
    
    func getPickupAreasOf(company: Int, destinationPoint: CGPoint) {
        print("getPickupAreasOf : \(company) - \(destinationPoint)")
        Task.init {
            let result = await self.companyRepository.getCompanyPickupAreas(
                companyId: company,
                destinationPoint: destinationPoint
            )

            pickupAreaSubject.send(result.toUiDataState())
        }
    }
    
    func getCurrentPickupAreas() -> PickupAreas? {
        return pickupAreaSubject.value.getDataContent()?.data
    }
    
    
    func enrollUserToCompanySessions(
        sessionIds: [Int],
        pickUpLocation: CGPoint
    ) {
        Task.init {
            let enrollResult = await self.companyRepository.enrollUserTo(
                sessions: sessionIds,
                pickUpLocation: pickUpLocation
            )

            enrollEventSubject.send(enrollResult.toUiDataState())
        }
    }
}


