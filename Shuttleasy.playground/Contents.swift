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
}


let formatter = ShuttleasyDateFormatter.shared

print(formatter.convertDateString(dateString: "2022-12-18T08:25:27.163"))
