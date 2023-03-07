//
//  CompanyRepository.swift
//  Shuttleasy
//
//  Created by OguzhanMac on 7.03.2023.
//

import Foundation

protocol CompanyRepository {
    func getCompanyDetail(with id: Int) -> Result<CompanyDetail, Error>
}

class CompanyRepositoryImpl: CompanyRepository {
    func getCompanyDetail(with id: Int) -> Result<CompanyDetail, Error> {
        //TODO: implement here
        return Result.success(
            CompanyDetail(
                id: 0,
                thumbnail:"",
                name: "", 
                email: "", 
                phone: "", 
                rating: 0,  
                totalRating: 0, 
                membershipDate: "", 
                comments: [],
                shuttles: []
            )
            
        )
    }
    
    
}
