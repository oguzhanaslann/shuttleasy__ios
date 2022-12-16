//
//  AppRepository.swift
//  Shuttleasy
//
//  Created by Oğuzhan Aslan on 16.12.2022.
//

import Foundation

class AppRepository {
    
    let memoryDataSource : MemoryDataSource
    let shuttleasyUserDefaults: ShuttleasyUserDefaults

    init(memoryDataSource : MemoryDataSource , shuttleasyUserDefaults: ShuttleasyUserDefaults) {
        self.memoryDataSource = memoryDataSource
        self.shuttleasyUserDefaults = shuttleasyUserDefaults
    }

    func initApplication() {
        // get auth token from local storage if exists
        let token = shuttleasyUserDefaults.getAuthToken()
        // if token exists send it to memory source
        memoryDataSource.setAuthToken(token: token)
    }
}
