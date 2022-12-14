//
//  ProfileViewController.swift
//  Shuttleasy
//
//  Created by Oğuzhan Aslan on 30.11.2022.
//

import UIKit
import Foundation
import Combine
import SnapKit
import Kingfisher

class ProfileViewController: BaseViewController {
    
    private let profileViewModel : ProfileViewModel = Injector.shared.injectProfileViewModel()
    private var userProfileObserver : AnyCancellable? = nil
    private var userLogoutObserver : AnyCancellable? = nil

    private static let phoneNumberTag: Int = 1
    private static let emailTag: Int = 2
    private static let darkModeSwitchTag: Int = 3

    private let profileBackgroundView : UIView = {
        let stackView  = UIView()
        stackView.backgroundColor = primaryContainer
        return stackView
    }()

    private lazy var profileImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.layer.borderWidth = 4
        imageView.layer.borderColor = backgroundColor.cgColor
        imageView.contentMode = .scaleAspectFill
        imageView.layer.backgroundColor = UIColor.gray.cgColor
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private lazy var profileTitle : UILabel = {
        let label = TitleMedium(text: "Profile", color : onPrimaryContainer)
        return label
    }()
    
    private lazy var penIcon: UIImageView = {
        let penIcon : UIImageView =  systemImage(systemName : "pencil")
        penIcon.tintColor = onPrimaryContainer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onEditProfileClicked))
        penIcon.addGestureRecognizer(tapGesture)
        penIcon.isUserInteractionEnabled = true
        return penIcon
    }()

    @objc func onEditProfileClicked() {
        Navigator.shared.navigateToProfileEdit()
    }

    private let profileName : UILabel = {
        let label = HeadlineSmall(text: "")
        return label
    }()
    

    private lazy var contactSectionView: UIView = {
        let stackView  = UIView()
        
        let header = sectionHeader(title: "Contact")
        stackView.addSubview(header)
        header.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalToSuperview()
            make.height.greaterThanOrEqualTo(48)
        }

        let phoneRow = sectionRowView(resImageName: "icPhone", value : "",valueTag : ProfileViewController.phoneNumberTag)
        stackView.addSubview(phoneRow)
        phoneRow.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.greaterThanOrEqualTo(header.snp.bottom).offset(8)
            make.height.greaterThanOrEqualTo(24)
        }

        let mailRow = sectionRowView(resImageName: "icMail", value : "", valueTag : ProfileViewController.emailTag)
        stackView.addSubview(mailRow)
        mailRow.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.greaterThanOrEqualTo(phoneRow.snp.bottom).offset(20)
            make.height.greaterThanOrEqualTo(24)
        }

        let qrRow = sectionRowIconLabelView(resImageName: "icQRCode",description : "QR Code")
        stackView.addSubview(qrRow)
        qrRow.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.greaterThanOrEqualTo(mailRow.snp.bottom).offset(20)
            make.height.greaterThanOrEqualTo(24)
        }
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onQrCodeClicked(_:)))
        qrRow.addGestureRecognizer(tapGesture)
        qrRow.isUserInteractionEnabled = true

        return stackView
    }()

    func getEmailLabel() -> UILabel {
        return contactSectionView.viewWithTag(ProfileViewController.emailTag) as! UILabel
    }

    func getPhoneNumberLabel() -> UILabel {
        return contactSectionView.viewWithTag(ProfileViewController.phoneNumberTag) as! UILabel
    }

    @objc func onQrCodeClicked(_ sender: UITapGestureRecognizer) {
        print("onQrCodeClicked")
    }

    private lazy var preferencesSectionView: UIView = {
         let stackView  = UIView()
        
        let header = sectionHeader(title: "Preferences")
        stackView.addSubview(header)
        header.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalToSuperview()
            make.height.greaterThanOrEqualTo(48)
        }

        let darkModeRow = sectionWithSwitchRow(
            switchTag: ProfileViewController.darkModeSwitchTag,
            title : "Dark Mode"
        )

        stackView.addSubview(darkModeRow)
        darkModeRow.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.greaterThanOrEqualTo(header.snp.bottom).offset(8)
            make.height.greaterThanOrEqualTo(24)
        }

    
        let deleteAccount = sectionRowIconLabelView(resImageName: "icTrash",description : "Delete Account")
        stackView.addSubview(deleteAccount)
        deleteAccount.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.greaterThanOrEqualTo(darkModeRow.snp.bottom).offset(24)
            make.height.greaterThanOrEqualTo(24)
        }

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onDeleteAccountClicked(_:)))
        deleteAccount.addGestureRecognizer(tapGesture)
        deleteAccount.isUserInteractionEnabled = true

        return stackView
    }()

    func getDarkModeSwitch() -> UISwitch {
        return preferencesSectionView.viewWithTag(ProfileViewController.darkModeSwitchTag) as! UISwitch
    }

    @objc func onDeleteAccountClicked(_ sender: UITapGestureRecognizer) {
        print("onDeleteAccountClicked")
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: { action in
             Navigator.shared.navigateToDeleteAccount()
        })

        showAlertDialog(
            title: "Delete Account",
            message: "Are you sure you want to delete your account?",
            actions: [cancelAction, deleteAction]
        )
    }

    lazy var generalSettingsSectionView  : UIView = {
        let uiView  = UIView()

        let header = sectionHeader(title: "General")
        uiView.addSubview(header)
        header.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalToSuperview()
            make.height.greaterThanOrEqualTo(48)
        }

        let privacyRow = sectionWithEnterIcon(title: "Privacy Policy")
        uiView.addSubview(privacyRow)
        privacyRow.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.greaterThanOrEqualTo(header.snp.bottom).offset(24)
            make.height.greaterThanOrEqualTo(24)
        }

        let tapGesturePrivacy = UITapGestureRecognizer(target: self, action: #selector(onPrivacyClicked(_:)))
        privacyRow.addGestureRecognizer(tapGesturePrivacy)
        privacyRow.isUserInteractionEnabled = true

        let termsRow = sectionWithEnterIcon(title: "Terms of Service")
        uiView.addSubview(termsRow)
        termsRow.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.greaterThanOrEqualTo(privacyRow.snp.bottom).offset(24)
            make.height.greaterThanOrEqualTo(24)
        }

        let tapGestureTerms = UITapGestureRecognizer(target: self, action: #selector(onTermsClicked(_:)))
        termsRow.addGestureRecognizer(tapGestureTerms)
        termsRow.isUserInteractionEnabled = true

        let logOutRow = sectionEndIcon(
            title: "Log Out",
            iconView : resImage(name: "icLogout")
        )
        
        let tapGestureLogOut = UITapGestureRecognizer(target: self, action: #selector(onLogOutClicked(_:)))
        logOutRow.addGestureRecognizer(tapGestureLogOut)
        logOutRow.isUserInteractionEnabled = true

        uiView.addSubview(logOutRow)
        logOutRow.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(termsRow.snp.bottom).offset(24)
            make.height.greaterThanOrEqualTo(24)
        }
        
         
        return uiView
    }()
    
    private func getGeneralSettingsSectionViewHeight() -> Int {
        return 192
    }

    @objc func onPrivacyClicked(_ sender: UITapGestureRecognizer) {
        print("onPrivacyClicked")
    }

    @objc func onTermsClicked(_ sender: UITapGestureRecognizer) {
        print("onTermsClicked")
    }

    @objc func onLogOutClicked(_ sender: UITapGestureRecognizer) {
        print("onLogOutClicked")

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let logOutAction = UIAlertAction(title: "Log Out", style: .destructive, handler: { action in
            self.profileViewModel.logOut()
        })

        showAlertDialog(
            title:"Log Out",
            message: "Are you sure you want to log out?",
            actions: [cancelAction, logOutAction]
        )
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
        profileViewModel.getUserProfile()
        subcribeObservers()
    }

    func initViews() {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.alwaysBounceVertical = true
        scrollView.alwaysBounceHorizontal = false
        scrollView.bounces = true
        scrollView.backgroundColor = .clear
        scrollView.tintColor = backgroundColor

        
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .top
        stackView.spacing = 0
        scrollView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
            make.height.greaterThanOrEqualToSuperview()
        }

        let view = stackView
        view.addSubview(profileImageView)
        profileImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(48)
            make.centerX.equalToSuperview()
            let dimensions = 122
            make.width.equalTo(dimensions)
            make.height.equalTo(dimensions)
            profileImageView.layer.cornerRadius = CGFloat((dimensions / 2))
        }

        view.addSubview(profileName)
        profileName.snp.makeConstraints { make in
            make.top.greaterThanOrEqualTo(profileImageView.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
        }
        
        view.addSubview(profileBackgroundView)
        profileBackgroundView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(-44)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.width.equalToSuperview()
            make.bottom.equalTo(profileImageView.snp.centerY)
        }

        view.bringSubviewToFront(profileImageView)
    
        view.addSubview(penIcon)
        penIcon.snp.makeConstraints { make in
            make.top.equalTo(profileBackgroundView.snp.top).offset(40)
            make.right.equalTo(profileBackgroundView.snp.right).offset(-16)
            make.width.equalTo(24)
            make.height.equalTo(24)
        }
        
        
        view.addSubview(profileTitle)
        profileTitle.snp.makeConstraints { make in
            make.top.equalTo(profileBackgroundView.snp.top).offset(40)
            make.centerX.equalToSuperview()
        }

        view.addSubview(contactSectionView)
        contactSectionView.snp.makeConstraints { make in
            make.top.equalTo(profileName.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
            make.height.greaterThanOrEqualTo(168)
        }

        view.addSubview(preferencesSectionView)
        preferencesSectionView.snp.makeConstraints { make in
            make.top.equalTo(contactSectionView.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
            make.height.greaterThanOrEqualTo(124)
        }
        

        setOnValueChangedSelectorToDarkModeSwitch()

        view.addSubview(generalSettingsSectionView)
        generalSettingsSectionView.snp.makeConstraints { make in
            make.top.equalTo(preferencesSectionView.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
            make.height.greaterThanOrEqualTo(getGeneralSettingsSectionViewHeight())
        }
    }
    
    private func setOnValueChangedSelectorToDarkModeSwitch() {
        let darkModeSwitch = getDarkModeSwitch()
        darkModeSwitch.addTarget(self, action: #selector(onDarkModeSwitchChanged(_:)), for: .valueChanged)
    }

    private func removeOnValueChangedSelectorFromDarkModeSwitch() {
        let darkModeSwitch = getDarkModeSwitch()
        darkModeSwitch.removeTarget(self, action: #selector(onDarkModeSwitchChanged(_:)), for: .valueChanged)
    }
    
    @objc func onDarkModeSwitchChanged(_ sender: UISwitch) {
        print("onDarkModeSwitchChanged")
       
        let selectedStyle : UIUserInterfaceStyle
        if sender.isOn {
            print("Dark mode is on")
            // UserDefaults.standard.set(true, forKey: "darkMode")
            selectedStyle = .dark
        } else {
            print("Dark mode is off")
           // UserDefaults.standard.set(false, forKey: "darkMode")
            selectedStyle = .light
        }
                
        
        WindowDelegate.shared.setApplicationUIStyle(style: selectedStyle)
        profileViewModel.updateDarkModePreference(isDarkMode: sender.isOn)
    }

    func subcribeObservers() {
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(onProfileUpdated),
            name: Notification.Name(NotificationEvents.profileUpdated.rawValue),
            object: nil
        )

        userProfileObserver = profileViewModel.publisher
            .receive(on: DispatchQueue.main)
            .sink( receiveCompletion: { completion in
                switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        self.showErrorSnackbar(message: error.localizedDescription)
                }
             }, receiveValue: { profileState in
                    profileState.onSuccess { [weak self] profileData in
                        let profile = profileData.data
                        self?.profileName.text = profile.profileName
                        self?.profileImageView.load(url: profile.profileImageUrl)
                        self?.getEmailLabel().text = profile.profileEmail
                        self?.getPhoneNumberLabel().text = profile.profilePhone

                        let darkMode = profileData.data.darkMode
                        self?.removeOnValueChangedSelectorFromDarkModeSwitch()
                        self?.getDarkModeSwitch().isOn = darkMode
                        self?.setOnValueChangedSelectorToDarkModeSwitch()

                    }
                }
            )

        userLogoutObserver = profileViewModel.userLogoutResultPublisher
            .receive(on: DispatchQueue.main)
            .sink( receiveCompletion: { [weak self] completion in
                    switch completion {
                        case .finished:
                            break
                        case .failure(let error):
                            self?.showErrorSnackbar(message: error.localizedDescription)
                    }
                }, receiveValue: { _ in
                    self.onUserLogout()
                }
            )

    }

    @objc func onProfileUpdated() {
        print("ProfileUpdated - event received")
        profileViewModel.getUserProfile()
    }

    func onUserLogout() {
          Navigator.shared.navigateToSignIn(clearBackStack: true)
    }
}


extension ProfileViewController {
    func sectionHeader(
        title : String,
        contentColor : UIColor = onBackgroundColor
    ) -> UIView {
        let view = UIView()
        let label = LabelLarge(text: title, color : contentColor)
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalToSuperview()
        }

        let line = lineView(color : contentColor)
        view.addSubview(line)
        line.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.greaterThanOrEqualTo(label.snp.bottom).offset(8)
            make.height.equalTo(1)
        }
        return view
    }
    
    private func lineView(color : UIColor) -> UIView {
        let view = UIView()
        view.backgroundColor = color
        return view
    }
    
    func sectionRowView(
        resImageName : String,
        value : String,
        valueTag: Int? = nil,
        contentColor : UIColor = onBackgroundColor
    ) -> UIView {
        let view = UIView()
        let image = resImage(name: resImageName)
        image.tintColor = contentColor
        view.addSubview(image)
        image.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalToSuperview()
        }

        let label = BodyMedium(text: value, color : contentColor)
        if let tag = valueTag {
            label.tag = tag
        }
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.right.equalTo(view.snp.right)
            
        }
        return view
    }

    func sectionRow(
        title : String,
        value : String,
        contentColor : UIColor = onBackgroundColor
    ) -> UIView {
        let view = UIView()
        let label = BodyMedium(text: title, color : contentColor)
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalToSuperview()
        }

        let valueLabel = BodyMedium(text: value,color: contentColor)
        view.addSubview(valueLabel)
        valueLabel.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.top.equalToSuperview()
        }
        return view
    }

    
    func sectionRowIconLabelView(
        resImageName : String,
        description : String,
        contentColor : UIColor = onBackgroundColor
    ) -> UIView {
        let view = UIView()
        let image = resImage(name: resImageName)
        view.addSubview(image)
        image.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        image.tintColor = contentColor

        let description = LabelMedium(text: description, color : contentColor)
        view.addSubview(description)
        description.snp.makeConstraints { make in
            make.left.greaterThanOrEqualTo(image.snp.right).offset(8)
            make.top.equalTo(image.snp.top)
            make.bottom.equalTo(image.snp.bottom)
        }
        
        let arrow = systemImage(systemName: "chevron.right", tint: contentColor)
        view.addSubview(arrow)
        arrow.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.centerY.equalToSuperview()
        }

        return view
    }

    func sectionWithEnterIcon(
        title : String
    ) -> UIView {
        return sectionEndIcon(title: title, iconView: systemImage(systemName: "chevron.right", tint: onBackgroundColor))
    }

    func sectionWithSwitchRow(
        switchTag : Int,
        title : String,
        titleColor : UIColor = onBackgroundColor
    ) -> UIView{
        let view = UIView()
        let label = LabelMedium(text: title, color: titleColor)
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalToSuperview()
        }

        let switchView = UISwitch()
        switchView.tintColor = onPrimaryColor
        switchView.onTintColor = primaryColor
        switchView.tag = switchTag

        view.addSubview(switchView)
        switchView.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.centerY.equalToSuperview()
        }

        return view
    }
    
    func sectionEndIcon(
        title : String,
        iconView : UIImageView,
        contentColor : UIColor = onBackgroundColor
    ) -> UIView {
        let view = UIView()
        let label = LabelMedium(text: title, color: contentColor)
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalToSuperview()
        }

        let arrow = iconView
        iconView.tintColor = contentColor
        view.addSubview(arrow)
        arrow.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        iconView.isUserInteractionEnabled = true

        return view
    }
}
