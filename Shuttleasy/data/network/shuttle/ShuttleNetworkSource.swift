//
//  ShuttleNetworkSource.swift
//  Shuttleasy
//
//  Created by Oğuzhan Aslan on 19.12.2022.
//

import Foundation


protocol ShuttleNetworkSource {
    func searchCompany(destinationName : String) async throws -> ShuttleSearchResultDTO
    func searchCompanyFor(destination: CGPoint) async throws -> ShuttleSearchResultDTO
    func getDestinationPoints() async throws -> [DestinationDTO]
}

class ShuttleNetworkSourceImpl : ShuttleNetworkSource {
    private let apiService : ApiService
    init (apiService : ApiService) {
        self.apiService = apiService
    }

    func searchCompany(destinationName: String) async throws -> ShuttleSearchResultDTO {
        let param = ApiParameters()
            .destinationName(destinationName.lowercased().trimmingCharacters(in: .whitespaces))
            .build()
        
        debugPrint(param)
        
        return try await apiService.postRequestAsync(
            type: ShuttleSearchResultDTO.self,
            url: ApiUrlManager.shared.searchShuttle(),
            parameters:param
        )
    }
    
    func searchCompanyFor(destination: CGPoint) async throws -> ShuttleSearchResultDTO {
        //TODO: Implement here
        // throw error 
        throw NSError(domain: "Not implemented", code: 0, userInfo: nil)
    }
    
    func getDestinationPoints() async throws -> [DestinationDTO] {
        return try await apiService.postRequestAsync(
            type: [DestinationDTO].self,
            url: ApiUrlManager.shared.getAllGeopoints()
        )
    }
    
}
