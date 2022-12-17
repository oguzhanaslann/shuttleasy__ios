//
//  ApiUrlManager.swift
//  Shuttleasy
//
//  Created by Oğuzhan Aslan on 8.12.2022.
//

import Foundation

let baseApiUrl = "https://shuttleasydatabase.azurewebsites.net/api/" //"https://api.shuttleasy.com/v1/"

class ApiUrlManager {
    static let shared = ApiUrlManager()
    
    private init() {}
    
    func signInPassenger() -> String {
        return baseApiUrl + "Passenger/Login"
    }

    func signInDriver() -> String {
        return baseApiUrl + "Driver/Login"
    }
    
    func signUpPassenger() -> String {
        return baseApiUrl + "Passenger/SignUp"
    }

    func sendResetCodeDriver() -> String {
        return baseApiUrl + "Driver/SendOTPEmail"
    }

    func sendResetCodePassenger() -> String {
        return baseApiUrl + "Passenger/SendOTPEmail"
    }

    func otpConfirmDriver() -> String {
        return baseApiUrl + "Driver/ValidateOTPEmail"
    }

    func otpConfirmPassenger() -> String {
        return baseApiUrl + "Passenger/ValidateOTPEmail"
    }
    
    func resetPasswordPassenger() -> String {
        return baseApiUrl + "Passenger/ResetPassword "
    }

    func resetPasswordDriver() -> String {
        return baseApiUrl + "Driver/ResetPassword "
    }
    
    func getDriverProfile() -> String {
        return baseApiUrl + "Driver/GetDriver"
    }
    
    func getPassengerProfile() -> String {
        return baseApiUrl + "Passenger/GetPassenger"
    }
    
    func editProfilePassenger() -> String {
        return baseApiUrl + "Passenger/UpdatePassenger"
    }
    
    func editProfileDriver() -> String {
        return baseApiUrl + "Driver/UpdateDriver"
    }

    func deleteProfile() -> String {
        return baseApiUrl + "Passenger/DeletePassenger"
    }
}
