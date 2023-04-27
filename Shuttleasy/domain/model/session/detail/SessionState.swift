//
//  SessionState.swift
//  Shuttleasy
//
//  Created by OguzhanMac on 24.04.2023.
//

import Foundation

enum SessionState {
    case notStarted
    case ongoing
    case completed
    case nextStopIsYou
}

extension SessionState {
    func isCancellable() -> Bool {
        return self == .notStarted || self == .ongoing
    }

    func canBeExtendable() -> Bool {
        return self == .ongoing
    }
}
