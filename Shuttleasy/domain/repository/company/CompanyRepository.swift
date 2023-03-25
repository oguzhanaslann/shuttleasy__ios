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
    
    func getCompanyDetail(with id: Int) async -> Result<CompanyDetail, Error> {
        if shouldUseDummyData() {
            return .success(getDummyCompanyDetail())
        } else {
            return await getCompanyDetailFromNetwork(with: id)
        }
    }
    
    private func getCompanyDetailFromNetwork(with id : Int) async -> Result<CompanyDetail, Error> {
        do {
            let compnayDetailDto = try await shuttleNetworkSource.getCompanyDetail(with: id)
            let company = getCompanyFrom(dto: compnayDetailDto)
            return .success(company)
        } catch {
            print("\(error.localizedDescription)")
            return .failure(parseProcessError(error))
        }
    }
    
    private func getCompanyFrom(dto: CompanyDetailDTO) -> CompanyDetail {
        //TODO: missing fields
        return CompanyDetail(
            id: dto.company?.id ?? 0  ,
            thumbnail: "",
            name: dto.company?.name ?? "",
            email: dto.company?.email ?? "",
            phone: dto.company?.phoneNumber ?? "",
            rating: dto.company?.rating ?? 0.0,
            totalRating: dto.company?.votesNumber ?? 0,
            membershipDate: "",
            comments: getCompanyComments(dto.commentDetails),
            shuttleCount: 0,
            slogan: ""
        )
    }
    
    private func getCompanyComments(_ comments : [CommentDetailDTO]?) ->  [Comment]{
        return comments?.map({ comment in
            Comment(
             comment: comment.comment ?? "",
             createdDate: ShuttleasyDateFormatter.shared.tryFormattingDateString(
                dateString: comment.date,
                targetFormat: "dd/MM/yyyy"
            ),
             user: getUser(from: comment)
            )
        }) ?? []
    }
    
    private func getUser(from : CommentDetailDTO) -> User {
        return User(
            fullName: getUserName(from: from),
            profilePhoto: from.profilePic ?? ""
        )
    }
    
    private func getUserName(from: CommentDetailDTO) -> String{
        let name = from.name ?? ""
        let surname = from.surname ?? ""
        return "\(name) \(surname)"
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
