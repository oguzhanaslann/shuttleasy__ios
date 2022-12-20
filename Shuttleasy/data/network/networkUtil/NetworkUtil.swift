import Foundation
import Alamofire


func parseProcessError( _ error: Error) -> Error {
    
    if let afError = error.asAFError {
        let errorCode = afError.responseCode
        
        switch errorCode {
            case 400 :
                return NSError(domain: "error", code: 400, userInfo: [NSLocalizedDescriptionKey : "Invalid request"])
            case 401 :
                return NSError(domain: "error", code: 401, userInfo: [NSLocalizedDescriptionKey : "Unauthorized"])
            case 403 :
                return NSError(domain: "error", code: 403, userInfo: [NSLocalizedDescriptionKey : "Forbidden"])
            case 404 :
                return NSError(domain: "error", code: 404, userInfo: [NSLocalizedDescriptionKey : "Not found"])
            case 500 :
                return NSError(domain: "error", code: 500, userInfo: [NSLocalizedDescriptionKey : "Internal server error"])
            case 502 :
                return NSError(domain: "error", code: 502, userInfo: [NSLocalizedDescriptionKey : "Bad gateway"])
            case 503 :
                return NSError(domain: "error", code: 503, userInfo: [NSLocalizedDescriptionKey : "Service unavailable"])
            case 504 :
                return NSError(domain: "error", code: 504, userInfo: [NSLocalizedDescriptionKey : "Gateway timeout"])
            default:
                return NSError(domain: "error", code: 500, userInfo: [NSLocalizedDescriptionKey : "Something went wrong"])
        }
        
    } else {
        return NSError(domain: "error", code: 500, userInfo: [NSLocalizedDescriptionKey : "Something went wrong"])
    }
}

