//
//  ToggleButton.swift
//  Shuttleasy
//
//  Created by OguzhanMac on 23.03.2023.
//

import UIKit

class ToggleButton: DynamicColorButton {
    
    private var toggleButtonColors: ToggleButtonColors = ToggleButtonColors()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureButton()
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureButton()
    }
    
    
    convenience init(with colors: ToggleButtonColors) {
        self.init(frame: CGRect.zero)
        self.toggleButtonColors = colors
        super.buttonColors = getButtonColors()
        configureButton()
        initButton()
    }
    
    private func configureButton() {
        layer.borderWidth = 1
        layer.cornerRadius = CGFloat(SHAPE_MEDIUM)
    }
    
    private func getButtonColors() -> ButtonColors {
        if isSelected {
            return toggleButtonColors.selectedColors
        } else {
            return toggleButtonColors.unselectedColors
        }
    }
    
    private func refreshButton() {
        initButton()
    }
    
    
    override var isSelected: Bool {
        didSet {
            if(isSelected) {
                super.buttonColors = self.toggleButtonColors.selectedColors
                refreshButton()
            } else {
                super.buttonColors = self.toggleButtonColors.unselectedColors
                refreshButton()
            }
        }
    }
}

struct ToggleButtonColors {
    let selectedColors: ButtonColors = ButtonColors(
        backgroundColor: primaryColor,
        onNormalColor: onPrimaryColor,
        disabledColor: neutral80,
        onDisabledColor: neutral60,
        outlineColor: primaryColor,
        disabledOutlineColor: .lightGray
    )
    let unselectedColors : ButtonColors = ButtonColors(
        backgroundColor: .clear,
        onNormalColor: primaryColor,
        disabledColor: neutral80,
        onDisabledColor: neutral60,
        outlineColor: primaryColor,
        disabledOutlineColor: .lightGray
    )
}
