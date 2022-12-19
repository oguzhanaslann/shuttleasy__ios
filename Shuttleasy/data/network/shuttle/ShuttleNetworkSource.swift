//
//  ShuttleNetworkSource.swift
//  Shuttleasy
//
//  Created by Oğuzhan Aslan on 19.12.2022.
//

import Foundation


protocol ShuttleNetworkSource {
    func searchShuttle(query : String) async throws -> ShuttleSearchResultDTO
}

class ShuttleNetworkSourceImpl : ShuttleNetworkSource {
    private let apiService : ApiService
    init (apiService : ApiService) {
        self.apiService = apiService
    }

    func searchShuttle(query: String) async throws -> ShuttleSearchResultDTO {
        return try await apiService.postRequestAsync(
            type: ShuttleSearchResultDTO.self,
            url: ApiUrlManager.shared.searchShuttle(),
            parameters: ApiParameters()
                .beginningDestination(query)
                .build()
        )
    }
}
