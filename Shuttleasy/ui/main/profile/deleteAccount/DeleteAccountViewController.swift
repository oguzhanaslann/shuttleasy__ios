//
//  DeleteAccountViewController.swift
//  Shuttleasy
//
//  Created by Oğuzhan Aslan on 10.12.2022.
//

import UIKit
import SnapKit
import Combine

class DeleteAccountViewController:  BaseViewController {

    private let deleteViewModel = Injector.shared.injectDeleteAccountViewModel()
    private var deleteResultObserver : AnyCancellable? = nil
    
    private static let emailInputFieldTag = 1000
    private static let passwordInputFieldTag = 1001


    lazy var emailAndPasswordInputSection : UIStackView = {
        let stack = UIStackView()
        stack.backgroundColor = backgroundColor
        stack.axis = .vertical
        stack.spacing = 36
        let emailSection: UIView = textInputSection(
            title: "Email",
            inputHint: "Email...",
            keyboardInputType: .emailAddress,
            textContentType: .emailAddress,
            inputFieldTag: DeleteAccountViewController.emailInputFieldTag
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
            isSecureEntry: true,
            inputFieldTag: DeleteAccountViewController.passwordInputFieldTag
        )

        stack.addArrangedSubview(passwordSection)

        passwordSection.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(56)
        }
        
        return stack
    }()

    func findEmailInputField() -> UITextField? {
        return emailAndPasswordInputSection.viewWithTag(DeleteAccountViewController.emailInputFieldTag) as? UITextField
    }

    func findPasswordInputField() -> UITextField? {
        return emailAndPasswordInputSection.viewWithTag(DeleteAccountViewController.passwordInputFieldTag) as? UITextField
    }
    
    func emailPasswordSectionHeight() -> Int {
        return 56 + 56 + 36 + 12
    }

    lazy var deleteAccountWarningView: UIView = {
        let view = UIView()
        view.backgroundColor = errorContainer
        view.layer.cornerRadius = roundedMediumCornerRadius
        view.layer.masksToBounds = true
            
        let warningText = "Please enter your account’s Email and password In order to continue deletion process \n\n Recall that you will not be able to recover the account and related information again."
        let warningLabel = BodySmall(text: warningText , color :onErrorContainer )
        warningLabel.textColor = onErrorContainer
        warningLabel.breakLineFromEndIfNeeded()
        view.addSubview(warningLabel)
        warningLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.left.right.equalToSuperview().inset(24)
            make.top.bottom.equalToSuperview().inset(12)
        }

        return view
    }()
    
    lazy var deleteButton: UIButton = {
        let button = LargeButton(
            titleOnNormalState: "Delete",
            backgroundColor: errorColor,
            titleColorOnNormalState: onErrorColor
        )

        button.setOnClickListener {
            self.onDeleteClicked()
        }
        
        return button
    }()
    
    
    func onDeleteClicked() {
        let email = findEmailInputField()?.text ?? ""
        guard isValidEmail(email) else {
            self.showErrorSnackbar(message: "Please enter a valid email")
            return
        }

        let password = findPasswordInputField()?.text ?? ""

        guard isValidPassword(password) else {
            self.showErrorSnackbar(message: "Please enter a valid password")
            return
        }

        deleteViewModel.deleteAccount(email: email, password: password)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Account Deletion"
        initViews()
        subscribeObservers()
    }

    private func initViews() {
        view.addSubview(emailAndPasswordInputSection)
        emailAndPasswordInputSection.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(48)
            make.left.right.equalToSuperview().inset(24)
            make.height.equalTo(emailPasswordSectionHeight())
        }

        view.addSubview(deleteAccountWarningView)
        deleteAccountWarningView.snp.makeConstraints { make in
            make.top.greaterThanOrEqualTo(emailAndPasswordInputSection.snp.bottom).offset(32)
            make.left.right.equalToSuperview().inset(24)
        }
        
        
        view.addSubview(deleteButton)
        deleteButton.snp.makeConstraints { make in
            make.bottom.lessThanOrEqualTo(view.snp.bottom).offset(-36)
            make.left.right.equalToSuperview().inset(24)
            make.height.equalTo(largeButtonHeight)
            make.centerX.equalToSuperview()
        }
    }

    private func subscribeObservers() {
        deleteResultObserver = deleteViewModel.deleteAccountPublisher
            .receive(on: DispatchQueue.main)
            .sink( receiveCompletion: {[weak self] completion in
            switch completion {
                case .finished:
                    break 
                case .failure(let error):
                    self?.showErrorSnackbar(message: error.localizedDescription)
            }
            }, receiveValue: { [weak self] resultBool in
                print("result \(resultBool)")
                self?.onAccountDeletionResult(resultBool)
            })
    }

    private func onAccountDeletionResult(_ result: Bool) {
        if result {
            Navigator.shared.navigateToSignIn(clearBackStack: true)
        } else {
            self.showErrorSnackbar(message: "Account deletion failed")
        }
    }
    
    override func getStatusBarColor() -> UIColor {
        return primaryContainer
    }
}


