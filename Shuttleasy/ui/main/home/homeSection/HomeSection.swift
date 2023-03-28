//
//  HomeSection.swift
//  Shuttleasy
//
//  Created by OguzhanMac on 28.03.2023.
//

import Foundation

enum HomeSection {
    case greeting(userProfile : UserProfile)
    case nextSession
    case upComingSessions
}


extension HomeSection {
    func priority() -> Int {
        switch self {
            case .greeting:
                return 0
            case .nextSession:
                return 1
            case .upComingSessions:
                return 2
        }
    }
}
