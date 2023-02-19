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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavBackButton(navigationItem: navigationItem, target: self, action: #selector(dismissView))
    }
    
    @objc func dismissView() {
        dismiss(animated: true, completion: nil)
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
            .sink( 
                receiveCompletion: {[weak self] completion in
                    switch completion {
                        case .finished:
                            break 
                        case .failure(let error):
                            self?.showErrorSnackbar(message: error.localizedDescription)
                    }
                }, 
                receiveValue: { [weak self] result in
                    result.onSuccess { data in
                        self?.onAccountDeletionResult(data.data)
                    }.onError { errorMessage in
                        self?.showErrorSnackbar(message: errorMessage)
                    }
                }
            )
    }

    private func onAccountDeletionResult(_ result: Bool) {
        if result {
            Navigator.shared.navigate(
                from: self,
                to: .signIn,
                clearBackStack: true,
                wrappedInNavigationController: true
            )
        } else {
            self.showErrorSnackbar(message: "Account deletion failed")
        }
    }
    
    override func getStatusBarColor() -> UIColor {
        return errorContainer
    }
    
    override func getNavigationBarTintColor() -> UIColor {
        return onErrorContainer
    }
    
    override func getNavigationBarBackgroundColor() -> UIColor {
        return errorContainer
    }
    
    override func getNavigationBarTitleStyle(titleColor: UIColor = onPrimaryContainer, font: UIFont = LabelLargeFont(16)) -> [NSAttributedString.Key : NSObject] {
        var attrs = super.getNavigationBarTitleStyle(titleColor: titleColor, font: font)
        attrs[NSAttributedString.Key.foregroundColor]  = getNavigationBarTintColor()
        return attrs
    }
}


