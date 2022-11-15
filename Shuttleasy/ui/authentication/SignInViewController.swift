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
    
    
    lazy var emailInput : UIStackView = {
        let stack = UIStackView()
        stack.backgroundColor = backgroundColor
        stack.axis = .vertical
        stack.spacing = 24
        let emailSection: UIView = textInputSection(
            title: "Email",
            inputHint: "Email..."
        )
        stack.addSubview(emailSection)
        // stack.addArrangedSubview()
        emailSection.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.greaterThanOrEqualTo(56)
        }
        
        let passwordSection: UIView = textInputSection(
            title: "Password",
            inputHint: "Password..."
        )
        stack.addSubview(passwordSection)
        passwordSection.snp.makeConstraints { make in
            make.top.greaterThanOrEqualTo(emailSection.snp.bottom).offset(24)
            make.left.right.equalToSuperview()
            make.height.greaterThanOrEqualTo(56)
        }
        

        let forgotPasswordText = UILabel()
        forgotPasswordText.attributedText = NSMutableAttributedString()
            .span("Forgot your password ? ",font: BodySmallFont(), foregroundColor: onBackgroundColor)
            .span("Reset password",font : BodySmallFont(),foregroundColor: primaryColor)
        forgotPasswordText.textAlignment = .center
        
        stack.addSubview(forgotPasswordText)
        forgotPasswordText.snp.makeConstraints { make in
            make.top.greaterThanOrEqualTo(passwordSection.snp.bottom).offset(24)
            make.left.right.equalToSuperview()
        }
        
        return stack
    }()
    
    
    func textInputSection(
        title : String,
        inputHint: String
    ) -> UIView {
        let section = UIStackView()
        
        let label = TitleSmall(text: title,color: onBackgroundColor)
        section.addSubview(label)
        label.snp.makeConstraints { make in
            make.top.greaterThanOrEqualToSuperview().offset(16)
            make.left.equalToSuperview().offset(24)
            label.breakLineFromEndIfNeeded()
        }
        
        let emailTextField = UITextField()
        emailTextField.placeholder = inputHint
        emailTextField.font = TitleSmallFont()
        emailTextField.borderStyle = .roundedRect
        emailTextField.keyboardType = .emailAddress
        emailTextField.returnKeyType = .done
        emailTextField.textColor = onBackgroundColor
        
        section.addSubview(emailTextField)
        emailTextField.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
            make.height.lessThanOrEqualTo(44)
            make.top.greaterThanOrEqualTo(label.snp.bottom).offset(8)
        }

        return section
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(logoContainer)
        logoContainer.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
        }
        
        
        view.addSubview(emailInput)
        emailInput.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(72)
        }
    }
}
