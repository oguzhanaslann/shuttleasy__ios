import Foundation

typealias SessionAreaDTO = [SessionAreaItemDTO]

struct SessionAreaItemDTO: Codable {
    let id: Int
    let sessionId: Int
    let polygonPoints: String

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case sessionId = "sessionId"
        case polygonPoints = "polygonPoints"
    }
}

