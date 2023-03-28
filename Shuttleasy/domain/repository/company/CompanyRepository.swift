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
        destinationPoint: CGPoint,
        sessionIds: [Int]
    ) async -> Result<[PickupArea],Error>
    
    func enrollUserTo(
        sessions: [Int],
        pickUpLocation: CGPoint
    ) async -> Result<Void,Error>
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
        return CompanyDetail(
            id: dto.company?.id ?? 0  ,
            thumbnail: "https://images.unsplash.com/photo-1544620347-c4fd4a3d5957?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=2369&q=80",
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
        destinationPoint: CGPoint,
        sessionIds: [Int]
    ) async -> Result<[PickupArea], Error> {
        if shouldUseDummyData() {
            return .success(getDummyPickupAreas(destinationPoint))
        } else {
            return await getCompanyPickupAreasFromNetwork(sessionIds: sessionIds)
        }
    }
    
    func getCompanyPickupAreasFromNetwork(
        sessionIds: [Int]
    ) async -> Result<[PickupArea], Error> {
        do {
            let result = try await shuttleNetworkSource.getCompanyPickUpAreas(
                sessionIds: sessionIds
            )
            
            let resultsWithPolygon = result.map {
                PickupArea(
                    id: $0.id,
                    sessionId: $0.sessionId,
                    polygon: parseJsonPointTuples($0.polygonPoints) ?? []
                )
            }.filter {
                !$0.polygon.isEmpty
            }
        
            return .success(resultsWithPolygon)
            
        } catch {
            return .failure(parseProcessError(error))
        }
    }
    
    
    func parseJsonPointTuples(_ pointTupleJson: String) -> [CGPoint]? {
        guard let data = pointTupleJson.data(using: .utf8) else { return nil }

        do {
            let coordinates = try JSONSerialization.jsonObject(with: data, options: []) as? [[Double]]
            
            guard let validCoordinates = coordinates else { return nil }
            
            var points: [CGPoint] = []
            for coordinate in validCoordinates {
                let point = CGPoint(x: coordinate[1], y: coordinate[0])
                points.append(point)
            }
            
            return points
        } catch {
            debugPrint("Error json parse: \(error.localizedDescription)")
            return nil
        }
    }
    
    func enrollUserTo(sessions: [Int], pickUpLocation: CGPoint) async -> Result<Void, Error> {
        if shouldUseDummyData() {
            return .success(())
        } else {
            return await enrollUserToSessions(pickUpLocation, sessions)
        }
    }
    
    private func enrollUserToSessions(_ pickUpLocation: CGPoint, _ sessions: [Int]) async -> Result<Void, Error>{
        do {
            let enrollResult = try await shuttleNetworkSource.enrollToSessions(
                pickupArea: pickUpLocation,
                sessionIds: sessions
            )
            
            return .success(())
        } catch {
            return .failure(parseProcessError(error))
        }
    }
}
