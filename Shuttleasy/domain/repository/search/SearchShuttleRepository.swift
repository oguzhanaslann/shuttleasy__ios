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

               result = resultDto.map({ element in
                   SearchResult(
                    companyId: element.companyID ?? SearchShuttleRepositoryImpl.NoCompanyId,
                    title: "",
                    imageUrl: "",
                    destinationPoint: CGPoint(),
                    rating: 4.8,
                    totalRating: 0,
                    //TODO: implement here,
                    sessionPickModel: []
                   )
               })
           }

           return .success(result)
       } catch {
           return .failure(parseProcessError(error))
       }
    }

    private func getDummySearchResults()  -> [SearchResult] {
        return [
            SearchResult(
                companyId: SearchShuttleRepositoryImpl.NoCompanyId,
                title: "Company Name",
                imageUrl: "",
                destinationPoint: CGPoint(x: 38.4189, y: 27.1287),
                rating: 4.8,
                totalRating: 0,
                sessionPickModel: [
                    SessionPickListModel(
                        dayName: "Name",
                        sessionPickList: [
                            SessionPickModel(sessionId: 0, isSelected: false, isEnabled: true, sessionTitle: "00:00"),
                            SessionPickModel(sessionId: 1, isSelected: true, isEnabled: true, sessionTitle: "01:00"),
                            SessionPickModel(sessionId: 2, isSelected: true, isEnabled: false, sessionTitle: "02:00"),
                            SessionPickModel(sessionId: 3, isSelected: false, isEnabled: false, sessionTitle: "03:00"),
                            SessionPickModel(sessionId: 4, isSelected: false, isEnabled: true, sessionTitle: "04:00"),
                            SessionPickModel(sessionId: 5, isSelected: false, isEnabled: true, sessionTitle: "05:00"),
                            SessionPickModel(sessionId: 6, isSelected: false, isEnabled: true, sessionTitle: "06:00")
                        ]
                    )
                ]
            )
        ]
    }
    
    
    func getDestinationPoints() async -> Result<[CGPoint], Error> {
        if shouldUseDummyData() {
            return .success(getDestinationPointsDummyData())
        } else {
           return await getDestinationPointsFromNetwork()
        }
    }
    
    
    private func getDestinationPointsDummyData()  -> [CGPoint] {
        return [
            CGPoint(x: 38.4189, y: 27.1287)
        ]
    }
    
    
    private func getDestinationPointsFromNetwork() async -> Result<[CGPoint], Error> {
        do {
            let destinationResult = try await shuttleNetworkSource.getDestinationPoints()
            let points = destinationResult
                .filter({ dto in
                    dto.latitude != nil && dto.longtitude != nil
                })
                .map { dto in
                    CGPoint(x: dto.latitude!, y: dto.longtitude!)
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

                result = resultDto.map({ element in
                    SearchResult(
                        companyId: element.companyID ?? SearchShuttleRepositoryImpl.NoCompanyId,
                        title: "",
                        imageUrl: "",
                        destinationPoint: CGPoint(),
                        rating: 4.8,
                        totalRating: 0,
                        sessionPickModel: []
                        //TODO: implement here
                    )
                })
            }

            return .success(result)
        } catch {
            return .failure(parseProcessError(error))
        }
    }

}
