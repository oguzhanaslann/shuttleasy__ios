//
//  BaseRepository.swift
//  Shuttleasy
//
//  Created by Oğuzhan Aslan on 13.12.2022.
//

import Foundation


class BaseRepository {
    func shouldUseDummyData() -> Bool {
        return true
    }
}

extension BaseRepository {
    internal func dummyUserAuthDto(isDriver:Bool) -> UserAuthDTO {
        let profileType: ProfileType
        
        if isDriver {
            profileType = .driver
        } else {
            profileType = .passenger
        }
      
        return UserAuthDTO(
            id: 1,
            profilePic: "",
            name:  "Oguzhan",
            surname: "Aslan",
            phoneNumber: "5398775750",
            email: "sample@gmail.com",
            city: "",
            passengerAddress:"",
            qrString: "",
            token: ""
        )
    }
    
    internal func getDestinationPointsDummyData()  -> [CGPoint] {
        return [
            CGPoint(x: 38.4189, y: 27.1287)
        ]
    }
    
    internal func getDummySearchResults()  -> [SearchResult] {
        return [
            SearchResult(
                companyId: -1,
                title: "Company Name",
                imageUrl: "",
                destinationPoint: CGPoint(x: 38.4189, y: 27.1287),
                rating: 4.8,
                totalRating: 0,
                sessionPickModel: [
                    SessionPickListModel(
                        dayName: "Name",
                        sessionPickList: [
                            SessionPickModel(sessionId: 0, isSelected: false, isEnabled: true, sessionTitle: "00:00"),
                            SessionPickModel(sessionId: 1, isSelected: true, isEnabled: true, sessionTitle: "01:00"),
                            SessionPickModel(sessionId: 2, isSelected: false, isEnabled: false, sessionTitle: "02:00"),
                            SessionPickModel(sessionId: 3, isSelected: false, isEnabled: false, sessionTitle: "03:00"),
                            SessionPickModel(sessionId: 4, isSelected: false, isEnabled: true, sessionTitle: "04:00"),
                            SessionPickModel(sessionId: 5, isSelected: false, isEnabled: true, sessionTitle: "05:00"),
                            SessionPickModel(sessionId: 6, isSelected: false, isEnabled: true, sessionTitle: "06:00")
                        ]
                    ),
                    SessionPickListModel(
                        dayName: "Name",
                        sessionPickList: [
                            SessionPickModel(sessionId: 0, isSelected: false, isEnabled: true, sessionTitle: "00:00"),
                            SessionPickModel(sessionId: 1, isSelected: true, isEnabled: true, sessionTitle: "01:00"),
                            SessionPickModel(sessionId: 2, isSelected: false, isEnabled: false, sessionTitle: "02:00"),
                            SessionPickModel(sessionId: 3, isSelected: false, isEnabled: false, sessionTitle: "03:00"),
                            SessionPickModel(sessionId: 4, isSelected: false, isEnabled: true, sessionTitle: "04:00"),
                            SessionPickModel(sessionId: 5, isSelected: false, isEnabled: true, sessionTitle: "05:00"),
                            SessionPickModel(sessionId: 6, isSelected: false, isEnabled: true, sessionTitle: "06:00")
                        ]
                    ),
                    SessionPickListModel(
                        dayName: "Name",
                        sessionPickList: [
                            SessionPickModel(sessionId: 0, isSelected: false, isEnabled: true, sessionTitle: "00:00"),
                            SessionPickModel(sessionId: 1, isSelected: true, isEnabled: true, sessionTitle: "01:00"),
                            SessionPickModel(sessionId: 2, isSelected: false, isEnabled: false, sessionTitle: "02:00"),
                            SessionPickModel(sessionId: 3, isSelected: false, isEnabled: false, sessionTitle: "03:00"),
                            SessionPickModel(sessionId: 4, isSelected: false, isEnabled: true, sessionTitle: "04:00"),
                            SessionPickModel(sessionId: 5, isSelected: false, isEnabled: true, sessionTitle: "05:00"),
                            SessionPickModel(sessionId: 6, isSelected: false, isEnabled: true, sessionTitle: "06:00")
                        ]
                    ),
                    SessionPickListModel(
                        dayName: "Name",
                        sessionPickList: [
                            SessionPickModel(sessionId: 0, isSelected: false, isEnabled: true, sessionTitle: "00:00"),
                            SessionPickModel(sessionId: 1, isSelected: true, isEnabled: true, sessionTitle: "01:00"),
                            SessionPickModel(sessionId: 2, isSelected: false, isEnabled: false, sessionTitle: "02:00"),
                            SessionPickModel(sessionId: 3, isSelected: false, isEnabled: false, sessionTitle: "03:00"),
                            SessionPickModel(sessionId: 4, isSelected: false, isEnabled: true, sessionTitle: "04:00"),
                            SessionPickModel(sessionId: 5, isSelected: false, isEnabled: true, sessionTitle: "05:00"),
                            SessionPickModel(sessionId: 6, isSelected: false, isEnabled: true, sessionTitle: "06:00")
                        ]
                    ),
                    SessionPickListModel(
                        dayName: "Name",
                        sessionPickList: [
                            SessionPickModel(sessionId: 0, isSelected: false, isEnabled: true, sessionTitle: "00:00"),
                            SessionPickModel(sessionId: 1, isSelected: true, isEnabled: true, sessionTitle: "01:00"),
                            SessionPickModel(sessionId: 2, isSelected: false, isEnabled: false, sessionTitle: "02:00"),
                            SessionPickModel(sessionId: 3, isSelected: false, isEnabled: false, sessionTitle: "03:00"),
                            SessionPickModel(sessionId: 4, isSelected: false, isEnabled: true, sessionTitle: "04:00"),
                            SessionPickModel(sessionId: 5, isSelected: false, isEnabled: true, sessionTitle: "05:00"),
                            SessionPickModel(sessionId: 6, isSelected: false, isEnabled: true, sessionTitle: "06:00")
                        ]
                    ),SessionPickListModel(
                        dayName: "Name",
                        sessionPickList: [
                            SessionPickModel(sessionId: 0, isSelected: false, isEnabled: true, sessionTitle: "00:00"),
                            SessionPickModel(sessionId: 1, isSelected: true, isEnabled: true, sessionTitle: "01:00"),
                            SessionPickModel(sessionId: 2, isSelected: false, isEnabled: false, sessionTitle: "02:00"),
                            SessionPickModel(sessionId: 3, isSelected: false, isEnabled: false, sessionTitle: "03:00"),
                            SessionPickModel(sessionId: 4, isSelected: false, isEnabled: true, sessionTitle: "04:00"),
                            SessionPickModel(sessionId: 5, isSelected: false, isEnabled: true, sessionTitle: "05:00"),
                            SessionPickModel(sessionId: 6, isSelected: false, isEnabled: true, sessionTitle: "06:00")
                        ]
                    ),SessionPickListModel(
                        dayName: "Name",
                        sessionPickList: [
                            SessionPickModel(sessionId: 0, isSelected: false, isEnabled: true, sessionTitle: "00:00"),
                            SessionPickModel(sessionId: 1, isSelected: true, isEnabled: true, sessionTitle: "01:00"),
                            SessionPickModel(sessionId: 2, isSelected: false, isEnabled: false, sessionTitle: "02:00"),
                            SessionPickModel(sessionId: 3, isSelected: false, isEnabled: false, sessionTitle: "03:00"),
                            SessionPickModel(sessionId: 4, isSelected: false, isEnabled: true, sessionTitle: "04:00"),
                            SessionPickModel(sessionId: 5, isSelected: false, isEnabled: true, sessionTitle: "05:00"),
                            SessionPickModel(sessionId: 6, isSelected: false, isEnabled: true, sessionTitle: "06:00")
                        ]
                    ),SessionPickListModel(
                        dayName: "Name",
                        sessionPickList: [
                            SessionPickModel(sessionId: 0, isSelected: false, isEnabled: true, sessionTitle: "00:00"),
                            SessionPickModel(sessionId: 1, isSelected: true, isEnabled: true, sessionTitle: "01:00"),
                            SessionPickModel(sessionId: 2, isSelected: false, isEnabled: false, sessionTitle: "02:00"),
                            SessionPickModel(sessionId: 3, isSelected: false, isEnabled: false, sessionTitle: "03:00"),
                            SessionPickModel(sessionId: 4, isSelected: false, isEnabled: true, sessionTitle: "04:00"),
                            SessionPickModel(sessionId: 5, isSelected: false, isEnabled: true, sessionTitle: "05:00"),
                            SessionPickModel(sessionId: 6, isSelected: false, isEnabled: true, sessionTitle: "06:00")
                        ]
                    )
                ]
            )
        ]
    }
    
    
    internal func getDummyCompanyDetail() -> CompanyDetail {
        return CompanyDetail(
            id: 0,
            thumbnail:"",
            name: "My company",
            email: "sample@sample.com",
            phone: "1234567890",
            rating: 4.5,
            totalRating: 100,
            membershipDate: "2 Yıl",
            comments: [
                Comment(
                    comment: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
                    createdDate: "17.02.2021",
                    user: User(
                        fullName: "Oguzhan Macit",
                        profilePhoto: ""
                    )
                )
            ],
            shuttleCount: 10,
            slogan: "The best company"
        )
    }
    
    
    internal func getDummyPickupAreas(_ point: CGPoint) -> [PickupArea] {
        return [
                PickupArea(
                    id: 0,
                    sessionId: 0,
                    polygon: [
                        CGPoint(x: point.x - 0.005, y: point.y - 0.005),
                        CGPoint(x: point.x - 0.005, y: point.y + 0.005),
                        CGPoint(x: point.x + 0.005, y: point.y + 0.005)
                    ]
                )
           ]
    }
}
