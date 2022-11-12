//
//  Constants.swift
//  Shuttleasy
//
//  Created by Oğuzhan Aslan on 12.11.2022.
//

import Foundation

let SHAPE_EXTRA_SMALL = 6
let SHAPE_SMALL = 8
let SHAPE_MEDIUM = 12
let SHAPE_LARGE = 24
let SHAPE_EXTRA_LARGE = 32


var roundedXSmallCornerRadius : CGFloat {
    get {
        return CGFloat(SHAPE_EXTRA_SMALL)
    }
}
var roundedSmallCornerRadius : CGFloat {
    get {
        return CGFloat(SHAPE_SMALL)
    }
}
var roundedMediumCornerRadius : CGFloat {
    get {
        return CGFloat(SHAPE_MEDIUM)
    }
}
var roundedLargeCornerRadius: CGFloat {
    get {
        return CGFloat(SHAPE_LARGE)
    }
}
var roundedXLargeCornerRadius : CGFloat {
    get {
        return CGFloat(SHAPE_EXTRA_LARGE)
    }
}
