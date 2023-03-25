//
//  SearchResult.swift
//  Shuttleasy
//
//  Created by Oğuzhan Aslan on 19.12.2022.
//

import Foundation
struct SearchResult {
    let companyId: Int
    let title: String
    let imageUrl : String
    let destinationPoint : CGPoint
    let rating : Double
    let totalRating: Int
    let sessionPickModel : [SessionPickListModel]
}
