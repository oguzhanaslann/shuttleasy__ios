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
//        depetures?.forEach {
//            print("depeture : id - \($0.id), startTime \($0.startTime) , sessionDate: \($0.sessionDate)")
//        }
        
        let uniqueDepetures = depetures?.unique(by: { $0.id }) ?? []
        var result : [SessionPickListModel] = []
        uniqueDepetures.forEach {
            result.append(
                SessionPickListModel(
                    dayName: $0.sessionDate ?? "",
                    sessionPickList: [$0.toSessionPickModel()]
                )
            )
        }

        let grouped = Dictionary(grouping: result, by: { $0.dayName })
            .mapValues { $0.flatMap { $0.sessionPickList } }
        
        
        result = grouped.map {
            SessionPickListModel(
                dayName: $0.key,
                sessionPickList: $0.value
            )
        }
        
        result.sort { priority($0) < priority($1) }

//        result.forEach {
//            print("result -- day : \($0.dayName)")
//            print("[")
//            $0.sessionPickList.forEach {
//                print("\($0)")
//            }
//            print("] -- result")
//        }
        
        return result
    }
    
    
    
    private func priority(_ sessionModel: SessionPickListModel ) -> Int {
        switch sessionModel.dayName.lowercased() {
            case "monday":
                return 1
            case "tuesday":
                return 2
            case "wednesday":
                return 3
            case "thursday":
                return 4
            case "friday":
                return 5
            case "saturday":
                return 6
            case "sunday":
                return 7
            default :
                return 8
        }
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
            isEnabled: getIfEnabled(),
            sessionTitle: ShuttleasyDateFormatter.shared.tryFormattingDateString(
                dateString: self.startTime,
                targetFormat: "HH:mm"
            ),
            sessionDate: self.startTime ?? ""
        )
    }
    
    private func getIfEnabled()  -> Bool{
        var isNotFull: Bool = false
        if let passengerCount = passengerCount, let capacity = capacity {
            isNotFull =  passengerCount < capacity
        }
            
        return self.isActive ?? false  && isNotFull
    }

    private func randomPositiveInt() -> Int {
        return Int.random(in: 1..<1000)
    }
}
