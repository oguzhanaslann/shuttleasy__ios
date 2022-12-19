//
//  SearchShuttleRepository.swift
//  Shuttleasy
//
//  Created by Oğuzhan Aslan on 19.12.2022.
//

import Foundation

protocol SearchShuttleRepository {
    func searchShuttle(query : String) async -> Result<[SearchResult], Error>
}

class SearchShuttleRepositoryImpl : BaseRepository ,SearchShuttleRepository {
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
                result = try await shuttleNetworkSource.searchShuttle(query: query).toSearchResults()
           }

           return .success(result)
       } catch {
           return .failure(error)
       }
    }

    private func getDummySearchResults()  -> [SearchResult] {
        return [
            SearchResult(title: "Title - 1 ", imageUrl: "", startDateText: "15:15 15 Aralık 2022", shutlleBusPlateNumber: "35 YSR 2001")
        ]
    }
}
