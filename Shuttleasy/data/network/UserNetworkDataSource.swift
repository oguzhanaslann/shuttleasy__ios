//
//  UserNetworkDataSource.swift
//  Shuttleasy
//
//  Created by Oğuzhan Aslan on 20.11.2022.
//

import Foundation
import Alamofire

typealias Token = String

struct FallibleEventResponse: Decodable {
    let result: Bool

    private enum CodingKeys: String, CodingKey {
        case result = "result"
    }
}

protocol  UserNetworkDataSource {
    func signInUser(email: String , password: String, isDriver : Bool) async throws -> UserAuthDTO
    func signUpUser(
        email: String,
        password: String,
        name :String,
        surname: String,
        phone : String
    ) async throws -> UserAuthDTO
    func sendResetCodeTo(email: String) async throws -> Bool
    func sendResetCode(code: String, email : String) async throws -> Token?
    func resetPassword(email :String, password: String) async throws
    func getUserProfile(userId: Int,isDriver: Bool) async throws -> UserProfileDTO
    func editProfile(profileEdit: ProfileEdit, isDriver : Bool) async throws -> UserProfileDTO
    func deleteAccount(email: String, password: String) async throws -> Bool
    func getActiveSessions() async throws -> ActiveSessionDTO
}

class UserNetworkDataSourceImpl : UserNetworkDataSource {

    let apiService: ApiService

    init(apiService: ApiService) {
        self.apiService = apiService
    }
    
    func signInUser(email: String, password: String, isDriver : Bool) async throws -> UserAuthDTO {
        if isDriver {
            return try await driverSignIn(email: email, password: password)
        } else  {
            return try await passengerSignIn(email: email, password: password)
        }
    }

    private func driverSignIn(email: String, password: String) async throws -> UserAuthDTO {
        print("UserNetworkDataSourceImpl - driverSignIn - email: \(email) - password")
        let driverDTO =  try await apiService.postRequestAsync(
            type: DriverDto.self,
            url: ApiUrlManager.shared.signInPassenger(),
            parameters: ApiParameters()
                .email(email)
                .password(password)
                .build()
        )
        
        return driverDTO.toUserAuthDTO()
    }

    private func passengerSignIn(email: String, password: String) async throws -> UserAuthDTO {
        print("UserNetworkDataSourceImpl - passengerSignIn - email: \(email) - password")
        let passengerDTO =  try await apiService.postRequestAsync(
            type: PassengerDto.self,
            url: ApiUrlManager.shared.signInPassenger(),
            parameters: ApiParameters()
                .email(email)
                .password(password)
                .build()
        )
        
        return passengerDTO.toUserAuthDTO()
    }


    // only sign up for passenger allowed in the app
    func signUpUser(
        email: String,
        password: String,
        name :String,
        surname: String,
        phone : String
    ) async throws -> UserAuthDTO {
        print("UserNetworkDataSourceImpl - signUpUser - email: \(email) - password")
       
        let passengerDTO =  try await apiService.postRequestAsync(
            type: PassengerDto.self,
            url: ApiUrlManager.shared.signUpPassenger(),
            parameters: ApiParameters()
                .email(email)
                .password(password)
                .name(name)
                .surname(surname)
                .phoneNumber(phone.withoutRegionCode())
                .build()
        )
        return passengerDTO.toUserAuthDTO()
    }
    
    

    func sendResetCodeTo(email: String) async throws -> Bool {
        print("UserNetworkDataSourceImpl - sendResetCodeTo - email: \(email)")
        
        let response =  await apiService.postRequestAsyncUnit(
            url: ApiUrlManager.shared.sendOtpEmail (),
            parameters: ApiParameters()
                .email(email)
                .build()
        )
        
        return  response != nil && (response?.statusCode ?? 0) >= 200 && (response?.statusCode ?? 0) < 300
    }

    func sendResetCode(code: String, email: String) async throws -> Token? {
        print("UserNetworkDataSourceImpl - sendResetCode - code: \(code)")
        let otpConfirmDto = try await apiService.postRequestAsync(
            type: OtpConfirmDto.self,
            url: ApiUrlManager.shared.otpConfirm(),
            parameters: ApiParameters()
                .email(email)
                .otp(code)
                .build()
        )
        return otpConfirmDto.token
    }

    func resetPassword(email: String, password:String) async throws {
        print("UserNetworkDataSourceImpl - resetPassword - password: \(password)")
        await apiService.postRequestAsyncUnit(
            url: ApiUrlManager.shared.resetPassword(),
            parameters: ApiParameters()
                .email(email)
                .password(password)
                .build()
        )
    }

    func getUserProfile(userId : Int, isDriver : Bool) async throws -> UserProfileDTO {
        if isDriver {
            return try await getDriverProfile(userId: userId)
        } else {
            return try await getPassengerProfile(userId: userId)
        }
    }

    private func getDriverProfile(userId: Int) async throws -> UserProfileDTO {
        let driverDTO = try await apiService.postRequestAsync(
            type: DriverDto.self,
            url: ApiUrlManager.shared.getDriverProfile(),
            parameters: ApiParameters().id(userId).build()
        )
    
        return driverDTO.toUserProfileDTO()
    }

    private func getPassengerProfile(userId: Int) async throws -> UserProfileDTO {
         let passengerDTO = try await apiService.postRequestAsync(
            type: PassengerDto.self,
            url: ApiUrlManager.shared.getPassengerProfile(),
            parameters: ApiParameters().id(userId).build()
        )
    
        return passengerDTO.toUserProfileDTO()
    }
    
    
    func editProfile(profileEdit: ProfileEdit, isDriver : Bool) async throws -> UserProfileDTO {
        print("UserNetworkDataSourceImpl - editProfile")
        if isDriver {
            return try await editDriverProfile(profileEdit: profileEdit)
        } else {
            return try await editPassengerProfile(profileEdit: profileEdit)
        }    
    }

    private func editDriverProfile(profileEdit: ProfileEdit) async throws -> UserProfileDTO {
        print("UserNetworkDataSourceImpl - editDriverProfile")
        let driverDTO =  try await apiService.postRequestAsync(
            type: DriverDto.self,
            url: ApiUrlManager.shared.editProfileDriver(),
            parameters: ApiParameters()
                .name(profileEdit.name)
                .surname(profileEdit.surname)
                .phoneNumber(profileEdit.phoneNumber.withoutRegionCode())
                .email(profileEdit.email)
                .profilePic("")
                .build()
        )
        
        return driverDTO.toUserProfileDTO()
    }

    private func editPassengerProfile(profileEdit: ProfileEdit) async throws -> UserProfileDTO {
        print("UserNetworkDataSourceImpl - editPassengerProfile")
        let passengerDTO =  try await apiService.postRequestAsync(
            type: PassengerDto.self,
            url: ApiUrlManager.shared.editProfilePassenger(),
            parameters: ApiParameters()
                .name(profileEdit.name)
                .surname(profileEdit.surname)
                .phoneNumber(profileEdit.phoneNumber.withoutRegionCode())
                .email(profileEdit.email)
                .city("")
                .profilePic("")
                .build()
        )
        
        return passengerDTO.toUserProfileDTO()
    }
        
    func deleteAccount(email: String, password: String) async throws -> Bool {
        print("UserNetworkDataSourceImpl - deleteAccount")
        let fallible = try await apiService.postRequestAsync(
            type: Bool.self,
            url: ApiUrlManager.shared.deleteProfile(),
            parameters: ApiParameters().email(email).password(password).build()
        )
        return fallible
    }
    
    func getActiveSessions() async throws -> ActiveSessionDTO {
        return try await apiService.postRequestAsync(
            type: ActiveSessionDTO.self,
            url: ApiUrlManager.shared.getMyShuttleSessions()
        )
    }
}


