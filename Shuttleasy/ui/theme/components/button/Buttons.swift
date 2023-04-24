//
//  Buttons.swift
//  Shuttleasy
//
//  Created by Oğuzhan Aslan on 13.11.2022.
//

import Foundation
import UIKit

func LargeButton(
    titleOnNormalState : String,
    buttonColors: ButtonColors = defaultButtonColors()
)  -> UIButton {
    let button = DynamicColorButton(with: buttonColors)
    button.setTitle(titleOnNormalState, for: .normal)
    if let label = button.titleLabel {
        label.font = ButtonFont()
    }
    
    button.layer.cornerRadius = roundedMediumCornerRadius
    return button
}

