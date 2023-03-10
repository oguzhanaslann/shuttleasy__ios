//
//  CompanyDetail.swift
//  Shuttleasy
//
//  Created by OguzhanMac on 7.03.2023.
//

import Foundation

struct CompanyDetail {
    let id : Int
    let thumbnail : String
    let name : String
    let email : String
    let phone : String
    let rating : Double
    let totalRating : Int
    let membershipDate : String
    let comments : [Comment]
    let shuttles : [Shuttle]
    let slogan : String?
}
