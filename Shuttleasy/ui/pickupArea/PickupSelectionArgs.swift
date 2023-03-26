//
//  PickupSelectionArgs.swift
//  Shuttleasy
//
//  Created by OguzhanMac on 16.03.2023.
//

import Foundation
import MapKit

typealias Polygon = [CGPoint]
typealias PickupAreas = [Polygon]

struct PickupSelectionArgs {
    let companyId: Int
    let destinationPoint : CGPoint
    let selectedSessionIds : [Int]
    let pickupAreas: PickupAreas?
}
