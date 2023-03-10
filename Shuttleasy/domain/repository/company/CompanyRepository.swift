//
//  CompanyRepository.swift
//  Shuttleasy
//
//  Created by OguzhanMac on 7.03.2023.
//

import Foundation

protocol CompanyRepository {
    func getCompanyDetail(with id: Int) async -> Result<CompanyDetail, Error>
}

class CompanyRepositoryImpl: CompanyRepository {
    func getCompanyDetail(with id: Int) -> Result<CompanyDetail, Error> {
        //TODO: implement here
        return Result.success(
            CompanyDetail(
                id: 0,
                thumbnail:"",
                name: "My company",
                email: "", 
                phone: "", 
                rating: 4.5,
                totalRating: 100,
                membershipDate: "2 Yıl",
                comments: [],
                shuttles: [],
                slogan: "The best company"
            )
            
        )
    }
    
    
}
