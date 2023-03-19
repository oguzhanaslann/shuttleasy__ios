//
//  PickupSelectionArgs.swift
//  Shuttleasy
//
//  Created by OguzhanMac on 16.03.2023.
//

import Foundation
import MapKit

typealias Polygon = [CLLocationCoordinate2D]
typealias PickupAreas = [Polygon]

struct PickupSelectionArgs {
    let destinationPoint : CGPoint
    let pickupAreas: PickupAreas?
}
