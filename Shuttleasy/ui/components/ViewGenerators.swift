//
//  ViewGenerators.swift
//  Shuttleasy
//
//  Created by Oğuzhan Aslan on 28.11.2022.
//

import Foundation
import SnapKit
import UIKit

func textInputSection(
    title : String,
    inputHint: String,
    keyboardInputType : UIKeyboardType = .default,
    textContentType: UITextContentType? = nil,
    isSecureEntry : Bool = false
) -> UIView {
    let section = UIStackView()
    
    let label = TitleSmall(text: title,color: onBackgroundColor)
    section.addSubview(label)
    label.snp.makeConstraints { make in
        make.top.greaterThanOrEqualToSuperview().offset(16)
        make.left.equalToSuperview().offset(24)
        label.breakLineFromEndIfNeeded()
    }
    
    let textInputField = UITextField()
    textInputField.font = TitleSmallFont()
    textInputField.borderStyle = .roundedRect
    textInputField.keyboardType = keyboardInputType
    textInputField.returnKeyType = .done
    textInputField.textColor = onBackgroundColor
    textInputField.layer.cornerRadius = roundedMediumCornerRadius
    textInputField.layer.masksToBounds = true
    textInputField.layer.borderWidth = 0.1
    textInputField.layer.borderColor = outline.cgColor
    textInputField.clipsToBounds = true
    textInputField.isSecureTextEntry = isSecureEntry
    if let contentType = textContentType {
        textInputField.textContentType = contentType
    }

    let hint = NSAttributedString(string: inputHint, attributes: [NSAttributedString.Key.foregroundColor: outline])
    textInputField.attributedPlaceholder = hint

    section.addSubview(textInputField)
    textInputField.snp.makeConstraints { make in
        make.left.equalToSuperview().offset(24)
        make.right.equalToSuperview().offset(-24)
        make.height.greaterThanOrEqualTo(50)
        make.top.greaterThanOrEqualTo(label.snp.bottom).offset(8)
    }

    return section
}
