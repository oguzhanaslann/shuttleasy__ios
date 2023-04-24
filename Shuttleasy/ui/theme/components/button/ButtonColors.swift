//
//  ButtonColors.swift
//  Shuttleasy
//
//  Created by OguzhanMac on 24.04.2023.
//

import Foundation
import UIKit

struct ButtonColors {
    let backgroundColor : UIColor
    let onNormalColor: UIColor
    let disabledColor : UIColor
    let onDisabledColor : UIColor
    let outlineColor: UIColor?
    let disabledOutlineColor : UIColor?
}

func defaultButtonColors() -> ButtonColors {
    return ButtonColors(
        backgroundColor: primaryColor,
        onNormalColor: onPrimaryColor,
        disabledColor: neutral80,
        onDisabledColor: .white,
        outlineColor: nil ,
        disabledOutlineColor: nil
    )
}

func errorButtonColors() -> ButtonColors {
    return ButtonColors(
        backgroundColor: errorColor,
        onNormalColor: onErrorColor,
        disabledColor: neutral80,
        onDisabledColor: .white,
        outlineColor: nil ,
        disabledOutlineColor: nil
    )
}

func errorTextButtonColors() -> ButtonColors {
    return ButtonColors(
        backgroundColor: .clear,
        onNormalColor: errorColor,
        disabledColor: .clear,
        onDisabledColor: neutral80,
        outlineColor: nil,
        disabledOutlineColor: nil
    )
}

func outlinedButtonColors() -> ButtonColors {
    return ButtonColors(
        backgroundColor: .clear,
        onNormalColor: primaryColor,
        disabledColor: neutral80,
        onDisabledColor: .white,
        outlineColor: primaryColor,
        disabledOutlineColor: neutral80
    )
}

