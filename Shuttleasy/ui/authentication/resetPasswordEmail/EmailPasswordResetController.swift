//
//  EmailPasswordResetController.swift
//  Shuttleasy
//
//  Created by Oğuzhan Aslan on 20.11.2022.
//

import UIKit
import Combine

class EmailPasswordResetController: BaseViewController {
    
    private let resetPasswordViewModel: EmailPasswordResetViewModel = Injector.shared.injectResetPasswordViewModel()
    private var codeSendResultObserver : AnyCancellable? = nil
    
    static let INPUT_TEXT_FIELD_INDEX = 1
    
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


    private lazy var resetAccountEmailInputSection : UIStackView = {
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
        
        return stack
    }()

    func getEmailInput() -> UITextField {
        return resetAccountEmailInputSection.arrangedSubviews[0].subviews[EmailPasswordResetController.INPUT_TEXT_FIELD_INDEX] as! UITextField
    }
    
    lazy var signInButton : UIButton = {
        let button = LargeButton(titleOnNormalState: "Next", backgroundColor: primaryColor, titleColorOnNormalState: onPrimaryColor)
        button.setOnClickListener {
           self.onResetPasswordClicked()
        }
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUi()
        subscribeObservers()
    }
    
    private func initUi() {
        view.addSubview(logoContainer)
        logoContainer.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
        }
        
        
        view.addSubview(resetAccountEmailInputSection)
        resetAccountEmailInputSection.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.left.right.equalToSuperview()
        }
        
                
        view.addSubview(signInButton)
        signInButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-24)
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
            make.height.equalTo(largeButtonHeight)
            make.centerX.equalToSuperview()
        }
    }

    func subscribeObservers()  {
        codeSendResultObserver =   resetPasswordViewModel.emailResetResult
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        self.showErrorSnackbar(message: error.localizedDescription)
                }
            } receiveValue: { result in
                print("email \(result)")
                if result {
                    self.navigateToResetCodePage()
                } else {
                    // TODO - IMPLEMENT ERROR HANDLING
                }
            }
    }

    func navigateToResetCodePage() {
        let email = getEmailInput().text!
        Navigator.shared.navigateToResetCode(userEmail: email)
    }

    func onResetPasswordClicked() {
        let email = getEmailInput().text ?? ""
        guard isValidEmail(email) else {
            self.showErrorSnackbar(message: "Please enter a valid email")
            return
        }
     
        resetPasswordViewModel.sendResetCodeTo(email: email)
    }
}
