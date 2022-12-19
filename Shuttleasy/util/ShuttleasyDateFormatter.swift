//
//  ShuttleasyDateFormatter.swift
//  Shuttleasy
//
//  Created by Oğuzhan Aslan on 19.12.2022.
//

import Foundation
class ShuttleasyDateFormatter {
    static let shared = ShuttleasyDateFormatter()

    static let format = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"

    private init() {}

    func convertDateString(dateString: String, format: String = ShuttleasyDateFormatter.format) -> String {
        let formatter = Foundation.DateFormatter()
        formatter.dateFormat = ShuttleasyDateFormatter.format
        let date = formatter.date(from: dateString)!
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
}
