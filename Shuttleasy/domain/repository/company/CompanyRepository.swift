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
                email: "sample@sample.com",
                phone: "1234567890", 
                rating: 4.5,
                totalRating: 100,
                membershipDate: "2 Yıl",
                comments: [
                    Comment(
                        id: 1,
                        comment: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
                        createdDate: "17.02.2021",
                        user: User(
                            id: 1,
                            fullName: "Oguzhan Macit",
                            profilePhoto: ""
                        )
                    ),
                    
                    Comment(
                        id: 1,
                        comment: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
                        createdDate: "17.02.2021",
                        user: User(
                            id: 1,
                            fullName: "Oguzhan Macit",
                            profilePhoto: ""
                        )
                    ),
                    
                    Comment(
                        id: 1,
                        comment: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
                        createdDate: "17.02.2021",
                        user: User(
                            id: 1,
                            fullName: "Oguzhan Macit",
                            profilePhoto: ""
                        )
                    )
                ],
                shuttles: [
                    Shuttle(
                        id: 1,
                        plateNumber: "34 AS 123",
                        driver: Driver(
                            id: 1,
                            name: "Oguzhan",
                            surname: "Macit"
                        ),
                        schedule: "Mon/Wed/Fri 10:00 - 12:00"
                    )
                ],
                slogan: "The best company"
            )
            
        )
    }
}
