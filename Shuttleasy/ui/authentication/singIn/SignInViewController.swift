//
//  SignInViewController.swift
//  Shuttleasy
//
//  Created by Oğuzhan Aslan on 13.11.2022.
//

import UIKit
import SnapKit
import Combine

class SignInViewController: BaseViewController {

    private let signInViewModel = Injector.shared.injectSignViewModel()
    private var cancellable : AnyCancellable? = nil

    private static let INPUT_TEXT_FIELD_INDEX = 1
    private static let driverFlagSwitchTag = 2

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

        let driverFlagSection = driverFlagSection()
        stack.addArrangedSubview(driverFlagSection)
        driverFlagSection.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(56)
        }

        let forgotPasswordLabel = UILabel()
        forgotPasswordLabel.attributedText =  NSMutableAttributedString()
            .span("Forgot your password ? ",font: BodySmallFont(), foregroundColor: onBackgroundColor)
            .span("Reset password", font : BodySmallFont(), foregroundColor: primaryColor)
        forgotPasswordLabel.textAlignment = .center
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(SignInViewController.navigateToResetPassword))
        forgotPasswordLabel.isUserInteractionEnabled = true
        forgotPasswordLabel.addGestureRecognizer(tap)
        
        stack.addArrangedSubview(forgotPasswordLabel)
        
        forgotPasswordLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(24)
        }
        
        return stack
    }()

    func getEmailInput() -> UITextField {
        return emailAndPasswordInputSection.arrangedSubviews[0].subviews[SignInViewController.INPUT_TEXT_FIELD_INDEX] as! UITextField
    }

    func getPasswordInput() -> UITextField {
        return emailAndPasswordInputSection.arrangedSubviews[1].subviews[SignInViewController.INPUT_TEXT_FIELD_INDEX] as! UITextField
    }

    lazy var signInButton : UIButton = {
        let button = LargeButton(titleOnNormalState: Localization.next.localized)
        button.setOnClickListener {
           self.onSignInClicked()
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
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(SignInViewController.navigateToSignUp))
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(tap)
        
        return label
    }()

    func driverFlagSection() -> UIView {
        let view = UIView()
        view.backgroundColor = backgroundColor
        let label = BodySmall(text: "I am a driver", color: onBackgroundColor)
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(8)
            make.centerY.equalToSuperview()
        }

        let switchButton = UISwitch()
        switchButton.tintColor = onPrimaryColor
        switchButton.onTintColor = primaryColor
        switchButton.tag =  SignInViewController.driverFlagSwitchTag
        switchButton.addTarget(self, action: #selector(SignInViewController.onDriverFlagSwitched), for: .valueChanged)
        view.addSubview(switchButton)
        switchButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-8)
            make.centerY.equalToSuperview()
        }

        view.layer.borderColor = outline.cgColor
        view.layer.borderWidth = 0.1
        view.layer.cornerRadius = roundedMediumCornerRadius
        view.layer.masksToBounds = true
    
        return view
    }

    @objc func onDriverFlagSwitched(sender: UISwitch) {}

    // get the driver flag switch by tag
    func getDriverFlagSwitch() -> UISwitch {
          return view.viewWithTag(SignInViewController.driverFlagSwitchTag) as! UISwitch
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

        subscribeObservers()
    }

    func subscribeObservers() {
      cancellable = signInViewModel.signInResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
            switch completion {
                case .finished:
                    break 
                case .failure(let error):
                    self?.showErrorSnackbar(message: error.localizedDescription)
            }
            
        } receiveValue: { [weak self] result in
            result.onSuccess { data in
                let isSuccess =  data.data

                if isSuccess {
                    self?.navigateToMainpage()
                } else {
                    self?.showErrorSnackbar(message: "Sign in failed")
                }
            }.onError { errorMessage in
                self?.showErrorSnackbar(message: errorMessage)
            }
        }
    }
    
    func navigateToMainpage() {
        Navigator.shared.navigateToMainpage(from: self,clearBackStack: true)
    }

    func onSignInClicked() {

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

        let isDriver = getDriverFlagSwitch().isOn
        
        signInViewModel.signInUser(email: email, password: password, isDriver: isDriver)
    }
    
    override func getNavigationBarBackgroundColor() -> UIColor {
        return .clear
    }
    
    override func getNavigationBarTintColor() -> UIColor {
        return .black
    }
    
    override func shouldSetStatusBarColor() -> Bool {
        return false
    }
    
    override func getStatusBarColor() -> UIColor {
        .clear
    }
    
    
    @objc
    func navigateToResetPassword() {
        Navigator.shared.navigateToEmailPasswordReset(from: self)
    }

    @objc
    func navigateToSignUp() {
        if !getDriverFlagSwitch().isOn {
            Navigator.shared.navigateToSignUp(from : self)
        } else {
            showErrorSnackbar(message: "Driver sign up is not allowed")
        }
        
    }
}
