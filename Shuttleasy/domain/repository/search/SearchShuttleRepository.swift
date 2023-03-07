import Foundation
import Alamofire

protocol SearchShuttleRepository {
    func searchShuttle(query : String) async -> Result<[SearchResult], Error>
}

class SearchShuttleRepositoryImpl : BaseRepository ,SearchShuttleRepository {
    
    private static let NoCompanyId = -1
    
    private let shuttleNetworkSource : ShuttleNetworkSource
    
    init(shuttleNetworkSource : ShuttleNetworkSource) {
        self.shuttleNetworkSource = shuttleNetworkSource
    }

    func searchShuttle(query: String) async -> Result<[SearchResult], Error> {
       do {
           let result : [SearchResult]

           if shouldUseDummyData() {
                result = getDummySearchResults()
           } else {
                let resultDto = try await shuttleNetworkSource.searchShuttle(query: query)

               result = resultDto.map({ element in
                   SearchResult(
                    companyId: element.companyID ?? SearchShuttleRepositoryImpl.NoCompanyId,
                    title: element.companyName ?? "",
                    imageUrl: "",
                    startDateText: ShuttleasyDateFormatter.shared.convertDateString(dateString: element.startTime ?? ""),
                    shutlleBusPlateNumber: element.busLicensePlate ?? ""
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
                title: "Title - 1 ",
                imageUrl: "",
                startDateText: "15:15 15 Aralık 2022",
                shutlleBusPlateNumber: "35 YSR 2001"
            )
        ]
    }
}
