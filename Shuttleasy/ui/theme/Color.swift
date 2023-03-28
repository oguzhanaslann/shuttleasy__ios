//
//  Color.swift
//  Shuttleasy
//
//  Created by Oğuzhan Aslan on 12.11.2022.
//

import Foundation
import UIKit

enum Color {
    case primary
    case onPrimary
    case primaryContainer
    case onPrimaryContainer
    case inversePrimary
    case secondary
    case onSecondary
    case secondaryContainer
    case onSecondaryContainer
    case tertiary
    case onTertiary
    case surface
    case onSurface
    case error
    case onError
    case errorContainer
    case onErrorContainer
    case background
    case onBackground
    case outline
    case surfaceVariant
    case onSurfaceVariant
    case neutral80
    case neutral60
    case neutral40
    case inverseSurface
    case onInverseSurface
}

func getUIColor(color : Color) -> UIColor {
    switch color {
        case .primary:
            return UIColor.init(named: "primary")!
        case .surface:
            return UIColor.init(named: "surface")!
        case .onPrimary:
            return UIColor.init(named: "onPrimary")!
        case .inversePrimary:
            return UIColor.init(named: "inversePrimary")!
        case .secondary:
            return UIColor.init(named: "secondary")!
        case .onSecondary:
            return UIColor.init(named: "onSecondary")!
        case .onSurface:
            return UIColor.init(named: "onSurface")!
        case .error:
            return UIColor.init(named: "error")!
        case .onError:
            return UIColor.init(named: "onError")!
        case .background:
            return UIColor.init(named: "background")!
        case .onBackground:
            return UIColor.init(named: "onBackground")!
        case .onPrimaryContainer:
            return UIColor.init(named: "onPrimaryContainer")!
        case .primaryContainer:
            return UIColor.init(named: "primaryContainer")!
        case .secondaryContainer:
            return UIColor.init(named: "secondaryContainer")!
        case .onSecondaryContainer:
            return UIColor.init(named :"onSecondaryContainer")!
        case .tertiary:
            return UIColor.init(named: "tertiary")!
        case .onTertiary:
            return UIColor.init(named: "onTertiary")!
        case .outline:
            return UIColor.init(named: "outline")!
        case .surfaceVariant:
            return UIColor.init(named: "surfaceVariant")!
        case .onSurfaceVariant:
            return UIColor.init(named: "onSurfaceVariant")!
        case .errorContainer:
            return UIColor.init(named: "errorContainer")!
        case .onErrorContainer:
            return UIColor.init(named: "onErrorContainer")!
        case .neutral60:
            return UIColor.init(named : "neutral60")!
        case .neutral80:
            return UIColor.init(named : "neutral80")!
        case .neutral40:
            return UIColor.init(named : "neutral40")!
        case .inverseSurface:
            return UIColor.init(named : "inverseSurface")!
        case .onInverseSurface:
            return UIColor.init(named : "onInverseSurface")!
    }
}

let primaryColor = getUIColor(color: .primary)
let onPrimaryColor = getUIColor(color: .onPrimary)
let primaryContainer = getUIColor(color: .primaryContainer)
let onPrimaryContainer = getUIColor(color: .onPrimaryContainer)
let secondaryColor = getUIColor(color: .secondary)
let onSecondaryColor = getUIColor(color: .onSecondary)
let surfaceColor = getUIColor(color: .surface)
let onSurfaceColor = getUIColor(color: .onSurface)
let errorColor = getUIColor(color: .error)
let onErrorColor = getUIColor(color: .onError)
let backgroundColor = getUIColor(color: .background)
let onBackgroundColor = getUIColor(color: .onBackground)
let outline = getUIColor(color: .outline)
let tertiary = getUIColor(color: .tertiary)
let onTertiary = getUIColor(color: .onTertiary)
let surfaceVariant = getUIColor(color: .surfaceVariant)
let onSurfaceVariant = getUIColor(color: .onSurfaceVariant)
let errorContainer = getUIColor(color: .errorContainer)
let onErrorContainer = getUIColor(color: .onErrorContainer)
let secondaryContainer = getUIColor(color: .secondaryContainer)
let onSecondaryContainer = getUIColor(color: .onSecondaryContainer)
let neutral60 = getUIColor(color: .neutral60)
let inversePrimary = getUIColor(color: .inversePrimary)
let neutral80 = getUIColor(color: .neutral80)
let neutral40 = getUIColor(color: .neutral40)
let inverseSurface = getUIColor(color: .inverseSurface)
let onInverseSurface = getUIColor(color: .onInverseSurface)