//
//  Localization.swift
//  Shuttleasy
//
//  Created by OguzhanMac on 9.02.2023.
//

import Foundation

enum Localization : String {
    case home = "home"
    case search = "search"
    case profile = "profile"
    case comments = "comments"
    case contact = "contact"
    case membership = "membership"
    case shuttles = "shuttles"
    case enroll = "enroll"
    case next = "next"
    case pickYourSessions = "pickYourSessions"

    
    var localized: String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
}


extension Localization {
    func localize(_ key : String? = nil) -> String {
        return NSLocalizedString( key ?? self.rawValue , comment: "")
    }
    
    static func localized( _ localization :Localization) -> String {
        return localization.localize()
    }
}

extension String {
    static func localized( _ localization :Localization) -> String {
        return localization.localize()
    }
}

