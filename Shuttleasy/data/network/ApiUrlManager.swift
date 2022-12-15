//
//  ApiUrlManager.swift
//  Shuttleasy
//
//  Created by Oğuzhan Aslan on 8.12.2022.
//

import Foundation

let baseApiUrl = "https://192.168.56.1:7129/api/" //"https://api.shuttleasy.com/v1/"

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
    
    func getUserProfile() -> String {
        return baseApiUrl + "profile"
    }
    
    func editProfile() -> String {
        return baseApiUrl + "Passenger/UpdatePassenger"
    }

    func deleteProfile() -> String {
        return baseApiUrl + "Passenger/Delete"
    }
}
