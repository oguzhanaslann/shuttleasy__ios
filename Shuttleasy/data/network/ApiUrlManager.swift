//
//  ApiUrlManager.swift
//  Shuttleasy
//
//  Created by Oğuzhan Aslan on 8.12.2022.
//

import Foundation

let baseApiUrl = "https://shuttleasydatabase.azurewebsites.net/api/"
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


    func sendOtpEmail() -> String {
        return baseApiUrl + "User/SendOTPEmail"
    }
    
    func otpConfirm() -> String {
        return baseApiUrl + "User/ValidateOTP"
    }

    func resetPassword() -> String {
        return baseApiUrl + "User/ResetPassword"
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

    func searchShuttle() -> String {
        return baseApiUrl + "ShuttleSession/SearchShuttle"
    }
}
