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
    
    private var titleFont = ButtonFont()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initButton()
        configureShape()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initButton()
        configureShape()
    }
    
    convenience init(with colors: ButtonColors) {
        self.init(frame: CGRect.zero)
        self.buttonColors = colors
        initButton()
        configureShape()
    }
    
    private func configureShape() {
        layer.cornerRadius = roundedSmallCornerRadius
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
                layer.borderWidth = 1
            }
        } else {
            backgroundColor = buttonColors.disabledColor
            if let disabledOutlineColor = buttonColors.disabledOutlineColor {
                layer.borderColor = disabledOutlineColor.cgColor
                layer.borderWidth = 1
            }
        }
    }
    
    
    override func setTitle(_ title: String?, for state: UIControl.State) {
        super.setTitle(title, for: state)
        applyFontToTitleIfPossible()
    }
    
    private func applyFontToTitleIfPossible() {
        if let label = self.titleLabel {
            label.font = titleFont
        }
    }
    
    func setFont(_ newFont : UIFont) {
        titleFont = newFont
        applyFontToTitleIfPossible()
    }
}