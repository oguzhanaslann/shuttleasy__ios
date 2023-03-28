//
//  HomeSection.swift
//  Shuttleasy
//
//  Created by OguzhanMac on 28.03.2023.
//

import Foundation

enum HomeSection: Equatable {
    case greeting(userProfile : UserProfile)
    case nextSession(nextSessionModel: NextSessionModel)
    case upComingSessionHeader
    case upComingSessions
    
    
    static func == (lhs: HomeSection, rhs: HomeSection) -> Bool {
        return lhs.priority() == rhs.priority()
    }
}


extension HomeSection {
    func priority() -> Int {
        switch self {
            case .greeting:
                return 0
            case .nextSession:
                return 1
            case .upComingSessionHeader:
                return 2
            case .upComingSessions:
                return 3
        }
    }
}
