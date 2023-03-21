//
//  CompanyDetailViewModel.swift
//  Shuttleasy
//
//  Created by OguzhanMac on 6.03.2023.
//

import Foundation
import Combine

class CompanyDetailViewModel : ViewModel {
    
    private let companyDetailSubject = CurrentValueSubject<UiDataState<CompanyDetail>, Error>(UiDataState.Initial)
    let companyDetailPublisher : AnyPublisher<UiDataState<CompanyDetail>, Error>
    
    private let companyRepository : CompanyRepository
    
    init(companyRepository: CompanyRepository) {
        self.companyRepository = companyRepository
        companyDetailPublisher = companyDetailSubject.eraseToAnyPublisher()
    }
    
    func getCompanyDetail(companyId : Int) {
        Task.init {
            let result = await self.companyRepository.getCompanyDetail(with: companyId)
            
            switch result  {
                case .success(let companyDetail):
                    companyDetailSubject.send(UiDataState.Success(.createFrom(data: companyDetail)))
                case .failure(let error):
                    companyDetailSubject.send(UiDataState.Error(error.localizedDescription))
            }
        }
    }
}
