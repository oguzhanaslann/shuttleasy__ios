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
    
    init(companyRepository: CompanyRepository) {
        self.companyRepository = companyRepository
        self.pickupAreaPublished = pickupAreaSubject.eraseToAnyPublisher()       
    }
    
    func getPickupAreasOf(company: Int, destinationPoint: CGPoint) {
        Task.init {
            let result = await self.companyRepository.getCompanyPickupAreas(
                companyId: company,
                destinationPoint: destinationPoint
            )
            
            switch result  {
                case .success(let companyDetail):
                    pickupAreaSubject.send(UiDataState.Success(.createFrom(data: companyDetail)))
                case .failure(let error):
                    pickupAreaSubject.send(UiDataState.Error(error.localizedDescription))
            }
        }
    }
    
    func getCurrentPickupAreas() -> PickupAreas? {
        return pickupAreaSubject.value.getDataContent()?.data
    }
    
}
