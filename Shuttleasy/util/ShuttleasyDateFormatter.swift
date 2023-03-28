//
//  ShuttleasyDateFormatter.swift
//  Shuttleasy
//
//  Created by Oğuzhan Aslan on 19.12.2022.
//

import Foundation
class ShuttleasyDateFormatter {
    static let shared = ShuttleasyDateFormatter()

    static let format = "yyyy-MM-dd'T'HH:mm:ss.SSS"
    static let target = "HH:mm dd MMMM yyyy"

    private init() {}

    func convertDateString(
        dateString: String,
        inputFormat : String = ShuttleasyDateFormatter.format,
        targetFormat : String = ShuttleasyDateFormatter.target
    ) -> String {
        let inputString = dateString
        print(inputString)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = inputFormat
       
        let date = dateFormatter.date(from: inputString)

        dateFormatter.dateFormat = targetFormat

        let outputString: String

        if let parseDate = date {
            outputString = dateFormatter.string(from: parseDate)
        } else {
            outputString = dateString
        }
        
        return outputString
    }


    func tryFormattingDateString(
        dateString : String? = nil,
        inputFormat : String = ShuttleasyDateFormatter.format,
        targetFormat : String = ShuttleasyDateFormatter.target
    ) -> String {
        if let dateString = dateString {
            do {
                return convertDateString(dateString: dateString, inputFormat: inputFormat, targetFormat: targetFormat)
            } catch {
                return ""
            }
        } else {
            return ""
        }
    }

    func convertDate(
        date: Date,
        targetFormat : String = ShuttleasyDateFormatter.target
    ) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = targetFormat
        return dateFormatter.string(from: date)
    }

    // try parsing date string in "format" to Date object
    func tryParsingDateString(
        dateString : String? = nil,
        inputFormat : String = ShuttleasyDateFormatter.format
    ) -> Date? {
        if let dateString = dateString {
            do {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = inputFormat
                return dateFormatter.date(from: dateString)
            } catch {
                return nil
            }
        } else {
            return nil
        }
    }
}

