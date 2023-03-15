//
//  SignUpViewController.swift
//  Shuttleasy
//
//  Created by Oğuzhan Aslan on 20.11.2022.
//

import UIKit
import Combine

class SignUpViewController: BaseViewController {

    private static let INPUT_TEXT_FIELD_INDEX = 1

    private lazy var logoContainer : UIView = {
            let view = UILabel()
            view.backgroundColor = primaryContainer
            let logo = resImageView(name: "logo")
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


    lazy var emailAndPasswordInputSection : UIStackView = {
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
        
        
        let privacyAgreementSection = privacyAgreementSection()
        stack.addArrangedSubview(privacyAgreementSection)
        privacyAgreementSection.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(56)
        }
                
        return stack
    }()

    lazy var privacyAgreementCheckbox : Checkbox = {
        let checkbox = Checkbox(frame : .zero)
        return checkbox    
    }()

    func privacyAgreementSection() -> UIView {
        let view = UIView()

        let checkbox = privacyAgreementCheckbox
        view.addSubview(checkbox)
        checkbox.snp.makeConstraints { make in
            make.left.equalToSuperview()
        }

        checkbox.setOnClickListener {
            checkbox.toggle()
        }
        
        let privacyText = LabelSmall(text: "I have read and I accept the Membership Agreement.")
        privacyText.textColor = onBackgroundColor
        privacyText.textAlignment = .center
        privacyText.breakLineFromEndIfNeeded()
        view.addSubview(privacyText)
        privacyText.snp.makeConstraints { make in
            make.left.greaterThanOrEqualTo(checkbox.snp.right)
            make.centerY.equalToSuperview()
            make.height.equalTo(24)
        }
        
        checkbox.snp.makeConstraints { make in
             make.centerY.equalToSuperview()
        }
            
        return view
    }

    // get if checkbox is checked
    func isPrivacyAgreementChecked() -> Bool {
        return privacyAgreementCheckbox.isChecked
    }

    func getEmailInput() -> UITextField {
        return emailAndPasswordInputSection.arrangedSubviews[0].subviews[SignUpViewController.INPUT_TEXT_FIELD_INDEX] as! UITextField
    }

    func getPasswordInput() -> UITextField {
        return emailAndPasswordInputSection.arrangedSubviews[1].subviews[SignUpViewController.INPUT_TEXT_FIELD_INDEX] as! UITextField
    }

    lazy var signUpButton : UIButton = {
        let button = LargeButton(titleOnNormalState: "Next", backgroundColor: primaryColor, titleColorOnNormalState: onPrimaryColor)
        button.setOnClickListener {
            self.onSignUpButtonClicked()
        }
        return button
    }()

    lazy var signInInsteadText : UILabel = {
        let label = UILabel()
        label.attributedText = NSMutableAttributedString()
            .span("Already have account ? ",font: BodySmallFont(), foregroundColor: onBackgroundColor)
            .span("Sign In.", font : BodySmallFont(),foregroundColor: primaryColor)
        label.textAlignment = .center
        label.breakLineFromEndIfNeeded()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(SignUpViewController.navigateToSignIn))
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(tap)
        
        return label
    }()
    
    @objc func navigateToSignIn() {
        Navigator.shared.popBack(from: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(logoContainer)
        logoContainer.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
        }
        
        
        view.addSubview(emailAndPasswordInputSection)
        emailAndPasswordInputSection.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
        }
        
        
        view.addSubview(signInInsteadText)
        signInInsteadText.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-32)
            make.centerX.equalToSuperview()
        }
        
        view.addSubview(signUpButton)
        signUpButton.snp.makeConstraints { make in
            make.bottom.lessThanOrEqualTo(signInInsteadText.snp.bottom).offset(-24)
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
            make.height.equalTo(largeButtonHeight)
            make.centerX.equalToSuperview()
        }
    }

    func onSignUpButtonClicked() {
        let isPrivacyAgreementChecked = self.isPrivacyAgreementChecked()

        guard isPrivacyAgreementChecked else {
             self.showErrorSnackbar(message: "You must accept the Membership Agreement.")
             return
        }
        
        let email = getEmailInput().text ?? ""

        guard isValidEmail(email) else {
            self.showErrorSnackbar(message: "Please enter a valid email")
            return 
        }

        let password = getPasswordInput().text ?? ""
        guard isValidPassword(password) else { 
            self.showErrorSnackbar(message : "Please enter a valid password")
            return
        }
        
        let signUpModelShort = SignUpModelShort(email: email, password: password)
        Navigator.shared.navigateToProfileSetup(from : self, signUpModelShort: signUpModelShort)
    }
}
