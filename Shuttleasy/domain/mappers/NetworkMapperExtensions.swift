//
//  NetworkMapperExtensions.swift
//  Shuttleasy
//
//  Created by Oğuzhan Aslan on 20.11.2022.
//

import Foundation


extension UserAuthDTO {
    func toUserAuthenticationModel() -> UserAuthenticationModel {
        return UserAuthenticationModel(
            id: self.id,
            authenticationToken: self.authenticationToken,
            profilePic: self.profilePic,
            name: self.name, 
            surname: self.surname, 
            phoneNumber: self.phoneNumber, 
            qrString: self.qrString,
            email: self.email,
            profileType: self.profileType
        )
    }
}


extension UserProfileDTO {
    func toUserProfile(isDarkMode : Bool) -> UserProfile {
        return UserProfile(
            profileType: self.profileType,
            profileImageUrl: self.profileImageUrl,
            profileName: self.profileName,
            profileSurname: self.profileSurname,
            profileEmail: self.profileEmail,
            profilePhone: self.profilePhone,
            qrSeed: qrSeed,
            darkMode: isDarkMode
        )
    }
}


extension ShuttleSearchResultDTO{
    func toSearchResults() -> [SearchResult] {
        return self.map { shuttleSearchResultDTOElement in
            SearchResult(
                title: shuttleSearchResultDTOElement.companyName ?? "",
                imageUrl: "", // TODO: implement when images added
                startDateText: ShuttleasyDateFormatter.shared.convertDateString(dateString: shuttleSearchResultDTOElement.startTime ?? ""),
                shutlleBusPlateNumber: shuttleSearchResultDTOElement.busLicensePlate ?? ""
            )
        }
    }
}

