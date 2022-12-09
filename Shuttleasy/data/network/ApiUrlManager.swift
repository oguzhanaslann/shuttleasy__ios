//
//  ApiUrlManager.swift
//  Shuttleasy
//
//  Created by Oğuzhan Aslan on 8.12.2022.
//

import Foundation

let baseApiUrl = "https://api.shuttleasy.com/v1/"

class ApiUrlManager {
    static let shared = ApiUrlManager()
    
    private init() {}
    
    func signInUser() -> String {
        return baseApiUrl + "auth/signin"
    }
    
    func signUpUser() -> String {
        return baseApiUrl + "passenger/auth/signup"
    }
    
    func sendResetCodeTo() -> String {
        return baseApiUrl + "auth/forgot-password"
    }

    func otpConfirm() -> String {
        return baseApiUrl + "auth/forgot-password/otp-confirm"
    }
    
    func resetPassword() -> String {
        return baseApiUrl + "auth/reset-password"
    }
    
    func getUserProfile() -> String {
        return baseApiUrl + "profile"
    }
    
    func editProfile() -> String {
        return baseApiUrl + "profile"
    }

    func deleteProfile() -> String {
        return baseApiUrl + "profile"
    }
    
    func getDriverVehicles() -> String {
        return baseApiUrl + "driver/vehicles"
    }
    
    func addDriverVehicle() -> String {
        return baseApiUrl + "driver/vehicles"
    }
    
    func editDriverVehicle() -> String {
        return baseApiUrl + "driver/vehicles"
    }

    func getDriverTrips() -> String {
        return baseApiUrl + "driver/trips"
    }
    
    func addDriverTrip() -> String {
        return baseApiUrl + "driver/trips"
    }
    
    func editDriverTrip() -> String {
        return baseApiUrl + "driver/trips"
    }
    
    func getDriverTripRequests() -> String {
        return baseApiUrl + "driver/trip-requests"
    }
    
    func getDriverTripRequest() -> String {
        return baseApiUrl + "driver/trip-requests"
    }
    
    func acceptDriverTripRequest() -> String {
        return baseApiUrl + "driver/trip-requests/accept"
    }
    
    func rejectDriverTripRequest() -> String {
        return ""
    }
}
