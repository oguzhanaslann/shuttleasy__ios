//
//  PickupArea.swift
//  Shuttleasy
//
//  Created by OguzhanMac on 27.03.2023.
//

import Foundation

typealias Polygon = [CGPoint]

struct PickupArea {
    let id: Int
    let sessionId: Int
    let polygon: Polygon
}
