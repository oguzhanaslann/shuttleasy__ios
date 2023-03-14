//
//  Driver.swift
//  Shuttleasy
//
//  Created by OguzhanMac on 10.03.2023.
//

import Foundation

struct Driver {
    let id: Int
    let name: String
    let surname: String
    
    var fullName: String {
        get {
            return "\(name) \(surname)"
        }
    }
}
    

