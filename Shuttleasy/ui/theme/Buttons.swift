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
    backgroundColor : UIColor,
    titleColorOnNormalState : UIColor
)  -> UIButton {
    let button = UIButton()
    button.setTitle(titleOnNormalState, for: .normal)
    if let label = button.titleLabel {
        label.font = ButtonFont()
    }
    button.backgroundColor = backgroundColor
    button.setTitleColor(titleColorOnNormalState, for: .normal)
    button.layer.cornerRadius = roundedMediumCornerRadius
    return button
}

