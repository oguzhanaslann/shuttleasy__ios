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
                rating: 4.8899999,
                totalRating: 100,
                sessionPickModel: [
                    SessionPickListModel(
                        dayName: "Monday",
                        sessionPickList: [
                            SessionPickModel(sessionId: 0, isSelected: false, isEnabled: true, sessionTitle: "departure", isDeparture : true),
                            SessionPickModel(sessionId: 1, isSelected: false, isEnabled: true, sessionTitle: "return1", isDeparture : false),
                            SessionPickModel(sessionId: 2, isSelected: false, isEnabled: true, sessionTitle: "isDeparture1", isDeparture : false),
                            SessionPickModel(sessionId: 3, isSelected: false, isEnabled: true, sessionTitle: "isDeparture2", isDeparture : false),
                            SessionPickModel(sessionId: 4, isSelected: false, isEnabled: true, sessionTitle: "return2", isDeparture : false),
                            SessionPickModel(sessionId: 5, isSelected: false, isEnabled: true, sessionTitle: "departure3", isDeparture : false),
                            SessionPickModel(sessionId: 6, isSelected: false, isEnabled: true, sessionTitle: "isDeparture3", isDeparture : false),
                            SessionPickModel(sessionId: 7, isSelected: false, isEnabled: true, sessionTitle: "00:00", isDeparture : false),
                            SessionPickModel(sessionId: 8, isSelected: false, isEnabled: true, sessionTitle: "01:00", isDeparture : false),
                            SessionPickModel(sessionId: 9, isSelected: false, isEnabled: true, sessionTitle: "02:00", isDeparture : false),
                            SessionPickModel(sessionId: 10, isSelected: false, isEnabled: true, sessionTitle: "03:00", isDeparture : false),
                            SessionPickModel(sessionId: 11, isSelected: false, isEnabled: true, sessionTitle: "04:00", isDeparture : false)

                        ]
                    ),
                    SessionPickListModel(
                        dayName: "Tuesday",
                        sessionPickList: [
                            SessionPickModel(sessionId: 0, isSelected: false, isEnabled: true, sessionTitle: "isDeparture2", isDeparture : false),
                            SessionPickModel(sessionId: 1, isSelected: true, isEnabled: true, sessionTitle: "return2", isDeparture : true)
                        ]
                    ),
                    SessionPickListModel(
                        dayName: "Wednesday",
                        sessionPickList: [
                            SessionPickModel(sessionId: 0, isSelected: false, isEnabled: true, sessionTitle: "departure3", isDeparture : false),
                            SessionPickModel(sessionId: 1, isSelected: true, isEnabled: true, sessionTitle: "isDeparture3", isDeparture : false)
                        ]
                    ),
                    SessionPickListModel(
                        dayName: "Thursday",
                        sessionPickList: [
                            SessionPickModel(sessionId: 0, isSelected: false, isEnabled: true, sessionTitle: "00:00", isDeparture : true),
                            SessionPickModel(sessionId: 1, isSelected: true, isEnabled: true, sessionTitle: "01:00", isDeparture : true)
                        ]
                    ),
                    SessionPickListModel(
                        dayName: "Friday",
                        sessionPickList: [
                            SessionPickModel(sessionId: 0, isSelected: false, isEnabled: true, sessionTitle: "00:00", isDeparture : false)
                        ]
                    ),SessionPickListModel(
                        dayName: "Saturday",
                        sessionPickList: [
                            SessionPickModel(sessionId: 0, isSelected: false, isEnabled: true, sessionTitle: "00:00", isDeparture : true)
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
                ),
                
                PickupArea(
                    id: 1,
                    sessionId: 1,
                    polygon: [
                        CGPoint(x: point.x - 0.005, y: point.y - 0.005),
                        CGPoint(x: point.x - 0.005, y: point.y + 0.005),
                        CGPoint(x: point.x + 0.005, y: point.y + 0.005)
                    ]
                ),

                PickupArea(
                    id: 2,
                    sessionId: 2,
                    polygon: [
                        CGPoint(x: point.x - 0.005, y: point.y - 0.005),
                        CGPoint(x: point.x - 0.005, y: point.y + 0.005),
                        CGPoint(x: point.x + 0.005, y: point.y + 0.005)
                    ]
                ),

                PickupArea(
                    id: 3,
                    sessionId: 3,
                    polygon: [
                        CGPoint(x: point.x - 0.005, y: point.y - 0.005),
                        CGPoint(x: point.x - 0.005, y: point.y + 0.005),
                        CGPoint(x: point.x + 0.005, y: point.y + 0.005)
                    ]
                ),

                PickupArea(
                    id: 4,
                    sessionId: 4,
                    polygon: [
                        CGPoint(x: point.x - 0.005, y: point.y - 0.005),
                        CGPoint(x: point.x - 0.005, y: point.y + 0.005),
                        CGPoint(x: point.x + 0.005, y: point.y + 0.005)
                    ]
                ),

                PickupArea(
                    id: 5,
                    sessionId: 5,
                    polygon: [
                        CGPoint(x: point.x - 0.005, y: point.y - 0.005),
                        CGPoint(x: point.x - 0.005, y: point.y + 0.005),
                        CGPoint(x: point.x + 0.005, y: point.y + 0.005)
                    ]
                ),

                PickupArea(
                    id: 6,
                    sessionId: 6,
                    polygon: [
                        CGPoint(x: point.x - 0.005, y: point.y - 0.005),
                        CGPoint(x: point.x - 0.005, y: point.y + 0.005),
                        CGPoint(x: point.x + 0.005, y: point.y + 0.005)
                    ]
                ),
                
           ]
    }
    
    internal func getDummyActiveSessions() -> [ActiveSession] {
        return [
            ActiveSession(
                sessionId: 0,
                plateNumber: "35SE3407",
                destinationName: "Konak pier",
                startDate: Date(),
                startLocation: .init(),
                endLocation: CGPoint(x: 38.4189, y: 27.1287),
                isReturn: false
            ),
            ActiveSession(
                sessionId: 1,
                plateNumber: "35SE3407",
                destinationName: "Konak pier",
                startDate: Date().addingTimeInterval(60*60*24),
                startLocation: .init(),
                endLocation: CGPoint(x: 38.4189, y: 27.1287),
                isReturn: false
            ),
        ]
    }
}
