//
//  SignInViewController.swift
//  Shuttleasy
//
//  Created by Oğuzhan Aslan on 13.11.2022.
//

import UIKit
import SnapKit

class SignInViewController: BaseViewController {

    
    lazy var logoContainer : UIView = {
        let view = UILabel()
        view.backgroundColor = primaryContainer
        let logo = resImage(name: "logo")
        view.addSubview(logo)
        logo.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.lessThanOrEqualTo(92)
            make.width.lessThanOrEqualTo(56)
            make.top.equalToSuperview().offset(64)
            make.bottom.equalToSuperview().offset(-16)
        }

        return view
    }()
    
    
    lazy var emailInputSection : UIStackView = {
        let stack = UIStackView()
        stack.backgroundColor = backgroundColor
        stack.axis = .vertical
        stack.spacing = 36
        let emailSection: UIView = textInputSection(
            title: "Email",
            inputHint: "Email...",
            keyboardInputType: .emailAddress,
            textContentType: .emailAddress
        )

        stack.addArrangedSubview(emailSection)
        emailSection.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(56)
        }
        
        let passwordSection: UIView = textInputSection(
            title: "Password",
            inputHint: "Password...",
            keyboardInputType: .default,
            textContentType: .password,
            isSecureEntry: true
        )
        
        stack.addArrangedSubview(passwordSection)
        
        passwordSection.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(56)
        }
        

        let forgotPasswordText = UILabel()
        forgotPasswordText.attributedText = NSMutableAttributedString()
            .span("Forgot your password ? ",font: BodySmallFont(), foregroundColor: onBackgroundColor)
            .span("Reset password", font : BodySmallFont(),foregroundColor: primaryColor)
        forgotPasswordText.textAlignment = .center

        stack.addArrangedSubview(forgotPasswordText)
        
        forgotPasswordText.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(48)
        }
        
        return stack
    }()
    
    
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
    
    
    lazy var signInButton : UIButton = {
        let button = LargeButton(titleOnNormalState: "Next", backgroundColor: primaryColor, titleColorOnNormalState: onPrimaryColor)
        button.setOnClickListener {
            //self.buttonAction()
            print("-click")
        }
        return button
    }()
    
    lazy var signUpInsteadText : UILabel = {
        let label = UILabel()
        label.attributedText = NSMutableAttributedString()
            .span("Do not have account ? ",font: BodySmallFont(), foregroundColor: onBackgroundColor)
            .span("Sign up.", font : BodySmallFont(),foregroundColor: primaryColor)
        label.textAlignment = .center
        label.breakLineFromEndIfNeeded()
        return label
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(logoContainer)
        logoContainer.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
        }
        
        
        view.addSubview(emailInputSection)
        emailInputSection.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.left.right.equalToSuperview()
        }
        
        
        view.addSubview(signUpInsteadText)
        signUpInsteadText.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-32)
            make.centerX.equalToSuperview()
        }
        
        view.addSubview(signInButton)
        signInButton.snp.makeConstraints { make in
            make.bottom.lessThanOrEqualTo(signUpInsteadText.snp.bottom).offset(-24)
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
            make.height.equalTo(largeButtonHeight)
            make.centerX.equalToSuperview()
        }
    }
    
    
}
