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
                )
            ],
            shuttleCount: 10,
            slogan: "The best company"
        )
    }
    
    private func getCompanyDetailFromNetwork(with id : Int) async -> Result<CompanyDetail, Error> {
        do {
            let compnayDetailDto = try await shuttleNetworkSource.getCompanyDetail(with: id)
            let company = getCompanyFrom(dto: compnayDetailDto)
            return .success(company)
        } catch {
            return .failure(parseProcessError(error))
        }
    }
    
    private func getCompanyFrom(dto: CompanyDetailDTO) -> CompanyDetail {
        //TODO: missing fields
        return CompanyDetail(
            id: dto.id,
            thumbnail: "",
            name: dto.name,
            email: dto.email,
            phone: dto.phoneNumber,
            rating: dto.rating,
            totalRating: dto.votesNumber,
            membershipDate: "",
            comments: [],
            shuttleCount: 0,
            slogan: ""
        )
    }
 
    func getCompanyPickupAreas(
        companyId: Int,
        destinationPoint: CGPoint
    ) async -> Result<PickupAreas, Error> {
        if shouldUseDummyData() {
            return .success(getDummyPickupAreas(destinationPoint))
        } else {
            //TODO: implement network connection 
            return .failure( NSError(domain: "Not implemented", code: 0, userInfo: nil))
        }
    }

    private func getDummyPickupAreas(_ point: CGPoint) -> PickupAreas {
        return [
                [
                    CGPoint(x: point.x - 0.005, y: point.y - 0.005),
                    CGPoint(x: point.x - 0.005, y: point.y + 0.005),
                    CGPoint(x: point.x + 0.005, y: point.y + 0.005),
                ]
           ]
    }
}
