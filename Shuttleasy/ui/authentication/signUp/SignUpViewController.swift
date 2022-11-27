//
//  SignUpViewController.swift
//  Shuttleasy
//
//  Created by Oğuzhan Aslan on 20.11.2022.
//

import UIKit
import Combine

class SignUpViewController: BaseViewController {

    private let signUpViewModel = Injector.shared.injectSignUpViewModel()
    private var cancellable : AnyCancellable? = nil

    private static let INPUT_TEXT_FIELD_INDEX = 1

    private lazy var logoContainer : UIView = {
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
            make.left.equalToSuperview().offset(24)
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
            make.left.greaterThanOrEqualTo(checkbox.snp.right).offset(8)
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

    lazy var signUpButton : UIButton = {
        let button = LargeButton(titleOnNormalState: "Next", backgroundColor: primaryColor, titleColorOnNormalState: onPrimaryColor)
        button.setOnClickListener {
            self.onSignInButtonClicked()
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
        Navigator.shared.popBack()
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
            make.left.right.equalToSuperview()
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

        subscribeObservers()
    }

     func subscribeObservers() {
      cancellable = signUpViewModel.signUpResult
            .receive(on: DispatchQueue.main)
            .sink { completion in
            switch completion {
                case .finished:
                    break 
                case .failure(let error):
                    self.showErrorSnackbar(message: error.localizedDescription)
            }
            
        } receiveValue: { result in
            self.navigateToMainpage()
        }
    }

    func navigateToMainpage() {
        Navigator.shared.navigateToMainpage(clearBackStack: true)
    }

    func onSignInButtonClicked() {
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

        signUpViewModel.signInUser(email: email, password: password)
    }
}
