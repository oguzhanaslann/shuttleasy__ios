//
//  DynamicColorButton.swift
//  Shuttleasy
//
//  Created by OguzhanMac on 15.03.2023.
//

import Foundation
import UIKit

class DynamicColorButton : UIButton {
    
    private var buttonColors: ButtonColors = ButtonColors()
    
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
    
    private func initButton() {
        setTitleColor(buttonColors.onNormalColor, for: .normal)
        setTitleColor(buttonColors.onDisabledColor, for: .disabled)
    }
    
    
    open override var isEnabled: Bool {
            didSet {
                if (isEnabled) {
                    backgroundColor = buttonColors.normalColor
                } else {
                    backgroundColor = neutral80
                }
            }
    }
    
}


struct ButtonColors {
    let normalColor = primaryColor
    let onNormalColor = onPrimaryColor
    let disabledColor : UIColor = neutral80
    let onDisabledColor : UIColor = .white
}
