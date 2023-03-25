//
//  DynamicColorButton.swift
//  Shuttleasy
//
//  Created by OguzhanMac on 15.03.2023.
//

import Foundation
import UIKit

class DynamicColorButton : UIButton {
    
    internal var buttonColors: ButtonColors = defaultButtonColors()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initButton()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initButton()
    }
    
    convenience init(with colors: ButtonColors) {
        self.init(frame: CGRect.zero)
        self.buttonColors = colors
        initButton()
    }
    
    internal func initButton() {
        setTitleColor(buttonColors.onNormalColor, for: .normal)
        setTitleColor(buttonColors.onDisabledColor, for: .disabled)
        setButtonBackgroundAndOutline(by: isEnabled)
    }
    
    open override var isEnabled: Bool {
            didSet {
                setButtonBackgroundAndOutline(by : isEnabled)
            }
    }
    
    private func setButtonBackgroundAndOutline(by state: Bool) {
        if (isEnabled) {
            backgroundColor = buttonColors.backgroundColor
            if let outlineColor = buttonColors.outlineColor {
                layer.borderColor = outlineColor.cgColor
            }
        } else {
            backgroundColor = neutral80
            if let disabledOutlineColor = buttonColors.disabledOutlineColor {
                layer.borderColor = disabledOutlineColor.cgColor
            }
        }
    }
    
}


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
