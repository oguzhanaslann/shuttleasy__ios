//
//  ProfileSetupViewController.swift
//  Shuttleasy
//
//  Created by Oğuzhan Aslan on 9.12.2022.
//

import UIKit
import Combine

struct SignUpModelShort {
    let email: String
    let password: String
}

class ProfileSetupViewController: BaseViewController {

    private let signUpViewModel = Injector.shared.injectSignUpViewModel()
    private var cancellable : AnyCancellable? = nil
    
    private static let nameInputTag = 1
    private static let surnameInputTag = 2
    private static let phoneInputTag = 3


    let signUpModelShort : SignUpModelShort
    init(signUpModelShort : SignUpModelShort){
        self.signUpModelShort = signUpModelShort
        super.init(nibName: nil, bundle: nil)
    }
       
    required init(coder : NSCoder){
        fatalError()
    }
    
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
       
    private lazy var inputSection: UIView = {
        let view = UIView()
        
        let nameInputSection = textInputSection(
                title: "Name",
                inputHint: "Name...",
                keyboardInputType: .default,
                textContentType: .name,
                inputFieldTag: ProfileSetupViewController.nameInputTag
        )
        view.addSubview(nameInputSection)
        nameInputSection.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top)
            make.left.equalToSuperview()
            make.right.equalTo(view.snp.centerX).offset(-12)
            make.height.equalTo(56)
        }


        let surnameInputSection = textInputSection(
                title: "Surname",
                inputHint: "Surname...",
                keyboardInputType: .default,
                textContentType: .familyName,
                inputFieldTag: ProfileSetupViewController.surnameInputTag
        )
        
        view.addSubview(surnameInputSection)
        surnameInputSection.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top)
            make.left.equalTo(view.snp.centerX).offset(12)
            make.right.equalToSuperview()
            make.height.equalTo(56)
        }        

        let phoneInputSection = Shuttleasy.phoneInputSection(
            title: "Phone",
            inputHint: "Phone...",
            inputFieldTag: ProfileSetupViewController.phoneInputTag
        )

        view.addSubview(phoneInputSection)
        phoneInputSection.snp.makeConstraints { make in
            make.top.greaterThanOrEqualTo(nameInputSection.snp.bottom).offset(36)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(56)
        }

        return view
    }()
    
    func findNameInput() -> UITextField? {
        return view.viewWithTag(ProfileSetupViewController.nameInputTag) as? UITextField
    }

    func findSurnameInput() -> UITextField? {
        return view.viewWithTag(ProfileSetupViewController.surnameInputTag) as? UITextField
    }
    
    func findPhoneInput() -> UITextField? {
        return view.viewWithTag(ProfileSetupViewController.phoneInputTag) as? UITextField
    }

    lazy var signUpButton : UIButton = {
        let button = LargeButton(
            titleOnNormalState: "Next"
        )
        button.setOnClickListener {
            self.onSignUpButtonClicked()
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

        view.addSubview(inputSection)
        inputSection.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)        
            make.height.equalTo(56 * 3 + 36)
        }

        let phoneInput = findPhoneInput()
        phoneInput?.addTarget(self, action: #selector(phoneInputChanged), for: .editingChanged)
        setPhoneInputText()
   
        view.addSubview(signUpButton)
        signUpButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-36)
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
            make.height.equalTo(largeButtonHeight)
            make.centerX.equalToSuperview()
        }
        
        subscribeObservers()
    }
    
    @objc func phoneInputChanged() {
        setPhoneInputText()
    }

    func setPhoneInputText() {
        let phoneInput = findPhoneInput()        
        let currentText: String = (phoneInput?.text?.count ?? 0) < 3 ? "" : (phoneInput?.text ?? "")
        phoneInput?.text = currentText.withPrefix(prefix: DEFAULT_PHONE_REGION, checkExistence: true)
    }

    func subscribeObservers() {
        cancellable = signUpViewModel.resultPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
            switch completion {
                case .finished:
                    break 
                case .failure(let error):
                    self?.showErrorSnackbar(message: error.localizedDescription)
            }
            
        } receiveValue: { [weak self] result in
            result.onSuccess { [weak self] data in
                let isSuccess = data.data
                if isSuccess {
                    print("sign up result: \(result)")
                    self?.navigateToMainpage()
                } else {
                    self?.showErrorSnackbar(message: "Sign up failed")
                }
                
            }.onError { [weak self] errorMessage in
                self?.showErrorSnackbar(message: errorMessage)
            }
        }
    }

    func navigateToMainpage() {
        Navigator.shared.navigateToMainpage(from : self,clearBackStack: true)
    }

    func onSignUpButtonClicked() {
        let name = findNameInput()?.text ?? ""
        guard name.isEmpty.not() else {
            self.showErrorSnackbar(message: "Please enter your name")
            return
        }

        let surname = findSurnameInput()?.text ?? ""
        guard surname.isEmpty.not() else {
            self.showErrorSnackbar(message: "Please enter your surname")
            return
        }
        let phone = findPhoneInput()?.text ?? ""
        guard isValidPhone(phone) else {
            self.showErrorSnackbar(message: "Please enter a valid phone number")
            return
        }

        signUpViewModel.signUpUser(
            email : self.signUpModelShort.email,
            password : self.signUpModelShort.password,
            name : name,
            surname : surname,
            phone : phone
        )
    }
}
