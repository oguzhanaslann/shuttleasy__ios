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
            if _token != nil {
                print("token get from memory source")
            }
            return _token
        }
    }

    func setAuthToken(token: String?) {
        if token != nil {
            print("token set to memory source : \(token!)")
        }
        _token = token
    }

    // key value pair
    private var _data: [String: Any] = [:]

    // key value with generic type
    func set<T>(key: String, value: T) {
        _data[key] = value
    }

    func get<T>(key: String) -> T? {
        return _data[key] as? T
    }

    func remove(key: String) {
        _data.removeValue(forKey: key)
    }
        
}
