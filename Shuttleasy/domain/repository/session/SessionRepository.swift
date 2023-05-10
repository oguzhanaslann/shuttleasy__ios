//
//  SessionRepository.swift
//  Shuttleasy
//
//  Created by OguzhanMac on 10.05.2023.
//

import Foundation
import Combine

protocol SessionRepository {
    func getDriverSessionDetail(sessionId: Int) async ->  Result<DriverSessionDetail, Error> 
}


class SessionRepositoryImpl: BaseRepository, SessionRepository {
    
    private let shuttleNetworkSource: ShuttleNetworkSource

    init(shuttleNetworkSource: ShuttleNetworkSource) {
        self.shuttleNetworkSource = shuttleNetworkSource
    }

    func getDriverSessionDetail(sessionId: Int) async -> Result<DriverSessionDetail, Error> {
        if shouldUseDummyData() {
            return .success(dummyDriverSessionDetail(sessionId: sessionId))
        } else {
          return await getDriverSessionDetailFromNetwork(sessionId: sessionId)
        }
    }
    
    private func getDriverSessionDetailFromNetwork(sessionId: Int) async -> Result<DriverSessionDetail, Error> {
        do {
            let passengerDTOs = try await shuttleNetworkSource.getDriverSessionPassengers(sessionId: sessionId)
            let passengers = passengerDTOs.toSessionPassengerModelList()
            return .success(DriverSessionDetail(id: sessionId, passengers: passengers))
        } catch {
            return .failure(parseProcessError(error))
        }
    }
    
}

extension SessionPassengersDTO {
    func toSessionPassengerModelList() -> [SessionPassenger] {
        return self.map { dto in
            SessionPassenger(
                id: generateUniqueInt(),
                profilePhoto: dto.profilePic ?? "",
                passengerName: dto.name ?? "" ,
                passengerAddress: dto.passengerAddress ?? "",
                passengerPhone: dto.phoneNumber ?? "",
                passengerEmail: dto.email ?? ""
            )
        }
    }
}
