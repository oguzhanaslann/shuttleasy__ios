//
//  CompanyDetailViewModel.swift
//  Shuttleasy
//
//  Created by OguzhanMac on 6.03.2023.
//

import Foundation
import Combine

class CompanyDetailViewModel : ViewModel {
    
    private let deleteAccountResult = CurrentValueSubject<UiDataState<CompanyDetail>, Error>(UiDataState.Initial)
    let deleteAccountPublisher : AnyPublisher<UiDataState<CompanyDetail>, Error>
    
    let companyRepository : CompanyRepository
    
    init(companyRepository: CompanyRepository) {
        self.companyRepository = companyRepository
        deleteAccountPublisher = deleteAccountResult.eraseToAnyPublisher()
    }
    
    func getCompanyDetail(companyId : Int) {
        
    }
    
    func enrollToShuttle(shuttleId : Int) {
        
    }
}
