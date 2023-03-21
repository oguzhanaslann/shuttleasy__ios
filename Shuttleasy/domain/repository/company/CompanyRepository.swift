//
//  CompanyRepository.swift
//  Shuttleasy
//
//  Created by OguzhanMac on 7.03.2023.
//

import Foundation

protocol CompanyRepository {
    func getCompanyDetail(with id: Int) async -> Result<CompanyDetail, Error>
    func getCompanyPickupAreas(
        companyId: Int,
        destinationPoint: CGPoint
    ) async -> Result<PickupAreas,Error>
}

class CompanyRepositoryImpl: BaseRepository, CompanyRepository {
    
    private let shuttleNetworkSource : ShuttleNetworkSource
    
    init(shuttleNetworkSource : ShuttleNetworkSource) {
        self.shuttleNetworkSource = shuttleNetworkSource
    }
    
    func getCompanyDetail(with id: Int) -> Result<CompanyDetail, Error> {
        //TODO: implement here
        if shouldUseDummyData() {
            return .success(getDummyCompanyDetail())
        } else {
            return .failure(NSError(domain: "Not implemented", code: 0, userInfo: nil))
        }
    }
    
    private func getDummyCompanyDetail() -> CompanyDetail {
        return  CompanyDetail(
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
            shuttleCount: 10,
            slogan: "The best company"
        )
    }
    
    
    func getCompanyPickupAreas(
        companyId: Int,
        destinationPoint: CGPoint
    ) async -> Result<PickupAreas, Error> {
        return .success(
           [
                [
                    CGPoint(x: 38.4189, y: 27.1287),
                    CGPoint(x: 38.4159, y: 27.1257),
                    CGPoint(x: 38.4209, y: 27.1257),
                ]
           ]
        )
    }
}
