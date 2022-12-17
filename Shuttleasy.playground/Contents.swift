

typealias Parameters = [String: Any]


class ApiParameters {
    var params : Parameters = [:]
    
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

    func build() -> Parameters {
        return params
    }
}


let api = ApiParameters()
    .id(1)
    .email("sadasd")
    .build()

print(api)
