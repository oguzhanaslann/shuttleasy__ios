import Foundation
import Alamofire

protocol SearchShuttleRepository {
    func searchCompanyFor(destinationName : String) async -> Result<[SearchResult], Error>
    func searchCompanyFor(destination: CGPoint) async -> Result<[SearchResult], Error>
    func getDestinationPoints() async -> Result<[CGPoint], Error>
}

class SearchShuttleRepositoryImpl : BaseRepository ,SearchShuttleRepository {
    private static let NoCompanyId = -1
    
    private let shuttleNetworkSource : ShuttleNetworkSource
    
    init(shuttleNetworkSource : ShuttleNetworkSource) {
        self.shuttleNetworkSource = shuttleNetworkSource
    }
    
    func searchCompanyFor(destinationName: String) async -> Result<[SearchResult], Error> {
       do {
           let result : [SearchResult]

           if shouldUseDummyData() {
                result = getDummySearchResults()
           } else {
                let resultDto = try await shuttleNetworkSource.searchCompany(destinationName: destinationName)
               
               result = mapResultToSearchResult(resultDto)
           }

           return .success(result)
       } catch {
           return .failure(parseProcessError(error))
       }
    }
    
    private func mapResultToSearchResult(_ resultDto: ShuttleSearchResultDTO) -> [SearchResult] {
        return resultDto.map({ element in
            SearchResult(
                companyId: element.companyDetail?.id ?? SearchShuttleRepositoryImpl.NoCompanyId,
                title: element.companyDetail?.name ?? "",
                imageUrl: "",
                destinationPoint: getDestinationPoint(element),
                rating: element.companyDetail?.rating ?? 0.0,
                totalRating: element.companyDetail?.votesNumber ?? 0,
                sessionPickModel: sessionPickListModels(element.shuttleSessionDeparture)
            )
        })
    }
    
    private func getDestinationPoint(_ result : ShuttleSearchResultDTOElement) -> CGPoint {
        var destinationPoint : CGPoint = .init()
        let deperature = result.shuttleSessionDeparture?.first(where: { deperature in
            return deperature.latitude != nil && deperature.longitude != nil
        })
        
        if let deperature = deperature {
            destinationPoint = .init(
                x: deperature.latitude?.toDoubleOrZero() ?? 0.0,
                y: deperature.longitude?.toDoubleOrZero() ?? 0.0
            )
        }
        
        return destinationPoint
    }
    
    
    private func sessionPickListModels(_ depetures : [ShuttleSessionDeparture]?) -> [SessionPickListModel] {
        
        let sessionPickModels = depetures?.map { $0.toSessionPickModel() } ?? []
        
        return depetures?.map({
            SessionPickListModel(
                dayName: $0.sessionDate ?? "",
                sessionPickList: sessionPickModels
            )
        }) ?? []
    }
    
    func getDestinationPoints() async -> Result<[CGPoint], Error> {
        if shouldUseDummyData() {
            return .success(getDestinationPointsDummyData())
        } else {
           return await getDestinationPointsFromNetwork()
        }
    }
    
    
    private func getDestinationPointsFromNetwork() async -> Result<[CGPoint], Error> {
        do {
            let destinationResult = try await shuttleNetworkSource.getDestinationPoints()
            let points = destinationResult
                .filter({ dto in
                    let length = dto.locationName?.count ?? 0
                    return length > 0 
                })
                .filter({ dto in
                    dto.latitude != nil && dto.longtitude != nil
                })
                .map({ dto in
                    Pair(first: dto.latitude!.toDoubleOrZero(), second: dto.longtitude!.toDoubleOrZero())
                })
                .filter({ coordinates in
                    coordinates.first != 0.0 && coordinates.second != 0.0
                })
                .map { dto in
                    CGPoint(x: dto.first, y: dto.second)
                }

            return .success(points)
        } catch {
            return .failure(parseProcessError(error))
        }
    }

    func searchCompanyFor(destination: CGPoint) async -> Result<[SearchResult], Error> {
        do {
            let result : [SearchResult]

            if shouldUseDummyData() {
                result = getDummySearchResults()
            } else {
                let resultDto = try await shuttleNetworkSource.searchCompanyFor(destination: destination)
                result = mapResultToSearchResult(resultDto)
            }

            return .success(result)
        } catch {
            return .failure(parseProcessError(error))
        }
    }

}

extension ShuttleSessionDeparture {
    func toSessionPickModel() -> SessionPickModel {
        return SessionPickModel(
            sessionId: id ?? randomPositiveInt(),
            isSelected: false,
            isEnabled: true,
            sessionTitle: ShuttleasyDateFormatter.shared.tryFormattingDateString(
                dateString: self.startTime,
                targetFormat: "HH:mm"
            )
        )
    }

    private func randomPositiveInt() -> Int {
        return Int.random(in: 1..<1000)
    }
}
