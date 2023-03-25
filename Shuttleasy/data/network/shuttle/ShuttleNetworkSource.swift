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
    func getCompanyDetail(with id: Int) async throws -> CompanyDetailDTO
    
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
        let param = ApiParameters()
            .build()
        
        return try await apiService.postRequestAsync(
            type: ShuttleSearchResultDTO.self,
            url: ApiUrlManager.shared.getShuttleByGeoPoint(),
            parameters:param
        )
    }
    
    func getDestinationPoints() async throws -> [DestinationDTO] {
        return try await apiService.postRequestAsync(
            type: [DestinationDTO].self,
            url: ApiUrlManager.shared.getAllGeopoints()
        )
    }
    
    func getCompanyDetail(with id: Int) async throws -> CompanyDetailDTO {
        let param = ApiParameters()
            .id(id)
            .build()
        
        return try await apiService.postRequestAsync(
            type: CompanyDetailDTO.self,
            url: ApiUrlManager.shared.getCompany(),
            parameters: param
        )
    }

}
