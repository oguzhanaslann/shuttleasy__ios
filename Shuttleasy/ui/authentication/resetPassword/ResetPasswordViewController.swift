//
//  ResetPasswordViewController.swift
//  Shuttleasy
//
//  Created by Oğuzhan Aslan on 28.11.2022.
//

import UIKit
import SnapKit
import Combine

class ResetPasswordViewController: BaseViewController {

    private let resetPasswordViewModel : ResetPasswordViewModel = Injector.shared.injectResetPasswordViewModel()
    private var resetPasswordObserve : AnyCancellable? = nil

    private let userEmail: String
    
    init(userEmail: String){
        self.userEmail  = userEmail
        super.init(nibName: nil, bundle: nil)
    }
       
    required init(coder : NSCoder){
        fatalError()
    }

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

    lazy var passwordInputSection : UIStackView = {
        let stack = UIStackView()
        stack.backgroundColor = backgroundColor
        stack.axis = .vertical
        stack.spacing = 36
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

        let passwordSectionAgain: UIView = textInputSection(
            title: "Password Again",
            inputHint: "Password Again...",
            keyboardInputType: .default,
            textContentType: .password,
            isSecureEntry: true
        )

        stack.addArrangedSubview(passwordSectionAgain)

        passwordSectionAgain.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(56)
        }
               
        return stack
    }()

    // get password uitextfield 
    func getPasswordTextField() -> UITextField {
        return passwordInputSection.arrangedSubviews[0].subviews[1] as! UITextField
    }

    // get password again uitextfield
    func getPasswordAgainTextField() -> UITextField {
        return passwordInputSection.arrangedSubviews[1].subviews[1] as! UITextField
    }

    lazy var resetButton : UIButton = {
        let button = LargeButton(titleOnNormalState: "Reset", backgroundColor: primaryColor, titleColorOnNormalState: onPrimaryColor)
        button.setOnClickListener {
           self.onResetPasswordClicked()
        }
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(logoContainer)
        logoContainer.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
        }

        view.addSubview(passwordInputSection)
        passwordInputSection.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
        }
        
        view.addSubview(resetButton)
        resetButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-36)
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
            make.height.equalTo(largeButtonHeight)
            make.centerX.equalToSuperview()
        }

        subscribeObservers()
    }

    func subscribeObservers() {
       resetPasswordObserve =  resetPasswordViewModel.resetPasswordResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                    case .finished:
                        break 
                    case .failure(let error):
                        self?.showErrorSnackbar(message: error.localizedDescription)
                }
            } receiveValue: { [weak self] result in
                result.onSuccess { resetted in
                    if resetted.data {
                        self?.showInformationSnackbar(message: "Password resetted successfully")
                        self?.navigateToMainpage()
                    } else {
                        self?.showErrorSnackbar(message: "Password reset failed")
                    }
                }.onError { errorMessage in
                    self?.showErrorSnackbar(message: errorMessage)
                }
            }
    }

    func navigateToMainpage() {
        Navigator.shared.navigateToMainpage(from : self, clearBackStack: true)
    }

    @objc
    func onResetPasswordClicked(){
        let password = getPasswordTextField().text ?? ""
        let passwordAgain = getPasswordAgainTextField().text ?? ""
        
        guard isValidPassword(password) else {
            self.showErrorSnackbar(message: "Password is not valid")
            return
        }
        
        guard password == passwordAgain else {
            self.showErrorSnackbar(message: "Passwords are not same")
            return
        }
        
        resetPasswordViewModel.resetPasswordOfUser(email: userEmail, password: password)
    }
}
