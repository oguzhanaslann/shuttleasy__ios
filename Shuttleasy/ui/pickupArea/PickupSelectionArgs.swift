//
//  PickupSelectionArgs.swift
//  Shuttleasy
//
//  Created by OguzhanMac on 16.03.2023.
//

import Foundation
import MapKit

struct PickupSelectionArgs {
    let companyId: Int
    let destinationPoint : CGPoint
    let sessionPickModels : [SessionPickListModel]
}
