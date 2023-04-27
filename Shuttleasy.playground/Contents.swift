//import Foundation
//
//func isValidPhone(_ phone: String) -> Bool {
//
//    if phone.count != 13 {
//        return false
//    }
//
//    let phoneRegex = "^\\+[0-9]{10,13}$"
//    let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
//    return phoneTest.evaluate(with: phone)
//}
//
//print("5553332211 : \(isValidPhone("5553332211"))")
//print("+905553332211 : \(isValidPhone("+905553332211"))")
//print("+9055533322111 : \(isValidPhone("+9055533322111"))")
//print("90555333222: \(isValidPhone("90555333222"))")
//
//
//let formatter = ShuttleasyDateFormatter.shared
//print(
//    formatter.tryFormattingDateString(
//        dateString: "2023-03-24T10:00:09.673",
//        targetFormat: "HH:mm"
//    )
//)
//
//
//print(
//    formatter.tryFormattingDateString(
//        dateString: "2023-03-24T10:00:09.673",
//        targetFormat: "dd/MM/yyyy"
//    )
//)
//
//
//
//let jsonString = """
//[[27.09320091895532,38.4005901313684],[27.09348368275448,38.3891769340278],[27.052058786185427,38.38186267605923],[27.053755368980546,38.39327701520847],[27.05460366037667,38.39072834820061],[27.06690388563885,38.404246463961016],[27.072841925420533,38.4001469474822],[27.07425574441575,38.3957147805302],[27.09320091895532,38.4005901313684]]
//"""
//
//
//func parseJsonPointTuples(_ pointTupleJson: String) -> [CGPoint]? {
//    guard let data = pointTupleJson.data(using: .utf8) else {
//        return nil
//    }
//
//    do {
//
//        let coordinates = try JSONSerialization.jsonObject(with: data, options: []) as? [[Double]]
//
//        guard let validCoordinates = coordinates else { return nil }
//
//        var points: [CGPoint] = []
//        for coordinate in validCoordinates {
//            let point = CGPoint(x: coordinate[0], y: coordinate[1])
//            points.append(point)
//        }
//
//        return points
//    } catch {
//        debugPrint("Error json parse: \(error.localizedDescription)")
//        return nil
//    }
//}
//
//print(parseJsonPointTuples(jsonString))

print(ShuttleasyDateFormatter.timeAndCalendarDateFormat())
print(ShuttleasyDateFormatter.timeAndExplicitDateFormat())
