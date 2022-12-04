//
//  ProfileEditViewController.swift
//  Shuttleasy
//
//  Created by Oğuzhan Aslan on 3.12.2022.
//

import UIKit
import Foundation
import Combine
import SnapKit
import Kingfisher

class ProfileEditViewController: BaseViewController {

    private static let emailInputTag = 1
    private static let nameInputTag = 2
    private static let surnameInputTag = 3
    private static let phoneInputTag = 4

    private let profileEditViewModel: ProfileEditViewModel = Injector.shared.injectProfileEditViewModel()
    private var userProfileObserver : AnyCancellable? = nil
    private var editProfileObserver : AnyCancellable? = nil

    private let profileTitle : UILabel = {
        let label = TitleMedium(text: "Edit Profile")
        return label
    }()
    
    private let profileImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.layer.borderWidth = 4
        imageView.layer.borderColor = backgroundColor.cgColor
        imageView.contentMode = .scaleAspectFill
        imageView.layer.backgroundColor = UIColor.gray.cgColor
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private let profileBackgroundView : UIView = {
        let stackView  = UIView()
        stackView.backgroundColor = primaryContainer
        return stackView
    }()
    
    private lazy var goBackIcon : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        button.tintColor = onBackgroundColor
        button.setOnClickListener {
            Navigator.shared.popBack()
        }
        return button
    }()

    private lazy var addNewPhotoView : UIView = {
        let view = UIView()
        view.backgroundColor = secondaryColor
        view.snp.makeConstraints { make in
            let size = 36
            make.size.equalTo(size)
            view.layer.cornerRadius = CGFloat((36 / 2))
        }
        
        let cameraIcon = systemImage(systemName: "camera.fill")
        cameraIcon.tintColor = onSecondaryColor

        view.addSubview(cameraIcon)
        cameraIcon.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        return view
    }()
    
    private lazy var nameInputSection : UIView = {
        let inputSection = textInputSection(
            title: "Name",
            inputHint: "Name...",
            keyboardInputType: .default,
            textContentType: .name,
            inputFieldTag: ProfileEditViewController.nameInputTag
        )
        return inputSection
    }()

    private lazy var surnameInputSection : UIView = {
        let inputSection = textInputSection(
            title: "Surname",
            inputHint: "Surname...",
            keyboardInputType: .default,
            textContentType: .familyName,
            inputFieldTag: ProfileEditViewController.surnameInputTag
        )
        return inputSection
    }()

    private lazy var emailInputSection : UIView = {
        let inputSection = textInputSection(
            title: "Email",
            inputHint: "Email...",
            keyboardInputType: .emailAddress,
            textContentType: .emailAddress,
            inputFieldTag: ProfileEditViewController.emailInputTag
        )
        return inputSection
    }()


    private lazy var phoneInputSection : UIView = {
        let inputSection = textInputSection(
            title: "Phone",
            inputHint: "Phone...",
            keyboardInputType: .phonePad,
            textContentType: .telephoneNumber,
            inputFieldTag: ProfileEditViewController.phoneInputTag
        )
        return inputSection
    }()

    func findNameInput() -> UITextField? {
        return view.viewWithTag(ProfileEditViewController.nameInputTag) as? UITextField
    }

    func findSurnameInput() -> UITextField? {
        return view.viewWithTag(ProfileEditViewController.surnameInputTag) as? UITextField
    }

    func findEmailInput() -> UITextField? {
        return view.viewWithTag(ProfileEditViewController.emailInputTag) as? UITextField
    }

    func findPhoneInput() -> UITextField? {
        return view.viewWithTag(ProfileEditViewController.phoneInputTag) as? UITextField
    }

    
    lazy var updateProfileInformationButton : UIButton = {
        let button = LargeButton(titleOnNormalState: "Update", backgroundColor: primaryColor, titleColorOnNormalState: onPrimaryColor)
        button.setOnClickListener {
            self.onUpdateClicked()
        }
        return button
    }()  
    
    func onUpdateClicked() {
        // TODO: Implement" 
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
        subcribeObservers()
        profileEditViewModel.getUserProfile(onlyWhenNeeded: true)
    }
    
    private func initViews() {
        view.addSubview(profileImageView)
        profileImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(122)
            make.centerX.equalToSuperview()
            let dimensions = 122
            make.width.equalTo(dimensions)
            make.height.equalTo(dimensions)
            profileImageView.layer.cornerRadius = CGFloat((dimensions / 2))
        }

        view.addSubview(addNewPhotoView)
        addNewPhotoView.snp.makeConstraints { make in
            make.bottom.equalTo(profileImageView.snp.bottom)
            make.right.equalTo(profileImageView.snp.right)
        }

        view.addSubview(profileBackgroundView)
        profileBackgroundView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.width.equalToSuperview()
            make.bottom.equalTo(profileImageView.snp.centerY)
        }

        view.bringSubviewToFront(profileImageView)
         view.bringSubviewToFront(addNewPhotoView)

        view.addSubview(profileTitle)
        profileTitle.snp.makeConstraints { make in
            make.top.equalTo(profileBackgroundView.snp.top).offset(56)
            make.centerX.equalToSuperview()
        }

        view.addSubview(goBackIcon)
        goBackIcon.snp.makeConstraints { make in
            make.top.equalTo(profileTitle.snp.top)
            make.left.equalToSuperview().offset(24)
            make.width.equalTo(28)
            make.height.equalTo(28)
        }

        view.addSubview(nameInputSection)
        nameInputSection.snp.makeConstraints { make in
            make.top.greaterThanOrEqualTo(profileImageView.snp.bottom).offset(24)
            make.left.equalToSuperview().offset(24)
            make.right.equalTo(view.snp.centerX)
            make.height.equalTo(56)
        }

        view.addSubview(surnameInputSection)
        surnameInputSection.snp.makeConstraints { make in
            make.top.greaterThanOrEqualTo(profileImageView.snp.bottom).offset(24)
            make.left.equalTo(view.snp.centerX).offset(12)
            make.right.equalToSuperview().offset(-24)
            make.height.equalTo(56)
        }

        view.addSubview(emailInputSection)
        emailInputSection.snp.makeConstraints { make in
            make.top.greaterThanOrEqualTo(nameInputSection.snp.bottom).offset(36)
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
            make.height.equalTo(56)
        }

        view.addSubview(phoneInputSection)
        phoneInputSection.snp.makeConstraints { make in
            make.top.greaterThanOrEqualTo(emailInputSection.snp.bottom).offset(36)
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
            make.height.equalTo(56)
        }


        view.addSubview(updateProfileInformationButton)
        updateProfileInformationButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-36)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-24)
            make.height.equalTo(largeButtonHeight)
        }
    }
    
    func subcribeObservers() {
        userProfileObserver = profileEditViewModel.userProfilePublisher
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                        case .finished:
                            break
                        case .failure(let error):
                            self.showErrorSnackbar(message: error.localizedDescription)
                    }
                }, receiveValue: { profileState in
                        profileState.onSuccess { profileData in
                            let profile = profileData.data
                            self.findNameInput()?.text = profile.profileName
                            self.findSurnameInput()?.text = profile.profileSurname
                            self.findEmailInput()?.text = profile.profileEmail
                            self.findPhoneInput()?.text = profile.profilePhone
                            self.profileImageView.load(url: profile.profileImageUrl)
                        }
                    }
            )
    }

}
