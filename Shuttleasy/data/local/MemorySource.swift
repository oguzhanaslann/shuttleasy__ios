//
//  MemorySource.swift
//  Shuttleasy
//
//  Created by Oğuzhan Aslan on 16.12.2022.
//

import Foundation

class MemoryDataSource : UserTokenProvider {
    
    static let shared = MemoryDataSource()
    private init() {}    
    
    private var  _token: String? = nil

    var token: String? {
        get {
            return _token
        }
    }

    func setAuthToken(token: String?) {
        print("token set to memory source")
        _token = token
    }
        
}
