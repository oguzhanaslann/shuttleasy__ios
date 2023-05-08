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
    case enrolledSuccessCallout = "enrolledSuccessCallout"
    case yourNextSessions = "yourNextSessions"
    case upCommingSessions = "upCommingSessions"
    case destination = "destination"
    case startTime = "startTime"
    case userGreeting = "userGreeting"
    case yourRide = "yourRide"
    case notStarted = "notStarted"
    case onGoing = "onGoing"
    case completed = "completed"
    case nextStopIsYou = "nextStopIsYou"
    case cancelMySession = "cancelMySession"
    case wait5Minutes = "wait5Minutes"
    case enable = "enable"
    case logout = "logout"
    case logoutConfirmation = "logoutConfirmation"
    case cancel = "cancel"
    case ok = "ok"
    case yes = "yes"
    case no = "no"
    case privacyPolicy = "privacyPolicy"
    case termsOfUse = "termsOfUse"
    case deleteAccount = "deleteAccount"
    case driverDeleteAccountAction = "driverDeleteAccountAction"
    case passengerDeleteAccountAction = "passengerDeleteAccountAction"
    case delete = "delete"
    case darkMode = "darkMode"
    case preferences = "preferences"
    case yourQr = "yourQr"
    case swipeBottomToDismiss = "swipeBottomToDismiss"
    case noResultFound = "noResultFound"
    case noSessionFound = "noSessionFound"
    case departure = "departure"
    case _return = "_return"

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

