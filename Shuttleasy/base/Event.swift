//
//  Event.swift
//  Shuttleasy
//
//  Created by OguzhanMac on 26.03.2023.
//

import Foundation

enum Event : String {
    case enrolled = "enrolledToShuttle"
}

func sendNotification(_ event : Event) {
    let notification = Notification(name: Notification.Name(event.rawValue))
    NotificationCenter.default.post(notification)
}

func notificationNamed (_ event: Event) -> NSNotification.Name {
    return NSNotification.Name(event.rawValue)
}
