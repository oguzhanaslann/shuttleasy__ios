//
//  MemoryDataSource.swift
//  Shuttleasy
//
//  Created by Oğuzhan Aslan on 7.12.2022.
//

import Foundation

class MemoryDataSource: UserTokenProvider {
    private init() {}
    static let shared = MemoryDataSource()
    
    var _token : String? = nil
    var token: String? {
        get { return _token }
    }
    
    func setAuthToken(token: String?) {
        self._token = token
    }
}
