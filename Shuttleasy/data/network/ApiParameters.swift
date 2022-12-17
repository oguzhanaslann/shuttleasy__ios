//
//  ApiParameters.swift
//  Shuttleasy
//
//  Created by Oğuzhan Aslan on 17.12.2022.
//

import Foundation
import Alamofire

class ApiParameters {

    private var params : Parameters = [:]
    
    func email(_ email: String) -> ApiParameters {
        params["email"] = email
        return self
    }

    func password(_ password: String) -> ApiParameters {
        params["password"] = password
        return self
    }

    func name(_ name: String) -> ApiParameters {
        params["name"] = name
        return self
    }

    func surname(_ surname: String) -> ApiParameters {
        params["surname"] = surname
        return self
    }

    func phoneNumber(_ phoneNumber: String) -> ApiParameters {
        params["phoneNumber"] = phoneNumber
        return self
    }

    func qrString(_ qrString: String) -> ApiParameters {
        params["qrString"] = qrString
        return self
    }

    func profilePic(_ profilePic: String) -> ApiParameters {
        params["profilePic"] = profilePic
        return self
    }
    
    func id(_ id: Int) -> ApiParameters {
        params["id"] = id
        return self
    }
    
    func city(_ city: String) -> ApiParameters {
        params["city"] = city
        return self
    }
    
    func otp(_ otp: String) -> ApiParameters {
        params["otp"] = otp
        return self
    }

    func build() -> Parameters {
        return params
    }
}
