//
//  HomepageViewContoller.swift
//  Shuttleasy
//
//  Created by Oğuzhan Aslan on 30.11.2022.
//

import UIKit
import SnapKit
import Combine

class HomepageViewContoller: BaseViewController {
    
    private let viewModel : HomeViewModel = Injector.shared.injectHomeViewModel()
    
    private var enrollNotificationObserver: NSObjectProtocol?
    private var profileObserver : AnyCancellable? = nil

    private static let USER_PROFILE_IMAGE_ID = 0
    private static let USER_FULL_NAME_ID = 1

    
    private lazy var greetingCard: UIView = {
        let container = UIView()
        container.backgroundColor = surfaceVariant
        container.layer.cornerRadius = roundedMediumCornerRadius
        
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.backgroundColor = UIColor.gray.cgColor
        imageView.layer.masksToBounds = true
        
        container.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            let size = 52
            make.size.equalTo(size)
            imageView.layer.cornerRadius = CGFloat((size / 2))
            make.left.equalToSuperview().offset(16)
        }
        
        
        let userFullName = BodyMedium(color: onSurfaceVariant)
        container.addSubview(userFullName)
        userFullName.snp.makeConstraints { make in
            make.left.greaterThanOrEqualTo(imageView.snp.right).offset(12)
            make.top.equalToSuperview().offset(12)
        }
    
        userFullName.tag = HomepageViewContoller.USER_FULL_NAME_ID
        
        let currentDate = LabelLarge(color: onSurfaceColor)
        container.addSubview(currentDate)
        currentDate.snp.makeConstraints { make in
            make.left.greaterThanOrEqualTo(imageView.snp.right).offset(12)
            make.top.greaterThanOrEqualTo(userFullName.snp.bottom).offset(8)
        }
        
        currentDate.text = ShuttleasyDateFormatter.shared.convertDate(
            date: Date(),
            targetFormat: "EEEE, dd MMMM"
        )
        
        return container
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = Localization.home.localized
        viewModel.getUserProfile()
        initViews()
        subscribeObserves()
    }
    
    private func initViews(){
        view.addSubview(greetingCard)
        greetingCard.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(24)
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
            make.height.equalTo(74)
        }
        greetingCard.isHidden = true
    }
    
    private func subscribeObserves() {
        subscribeToEnrollNotification()
        subscribeToProfile()
    }

    private func subscribeToEnrollNotification() {
       enrollNotificationObserver = NotificationCenter.default.addObserver(
            forName: notificationNamed(.enrolled),
            object: nil,
            queue: .main
        ) { [weak self] notification in
            // Handle the notification
            print("Enrolled to shuttle")
        }
    }
    
    private func subscribeToProfile() {
        profileObserver = viewModel.userProfilePublisher
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.handleCompletion(completion)
                },
                receiveValue: { [weak self] profileState in
                    profileState.onSuccess { userProfileContent in
                        self?.greetingCard.isHidden = false
                        let userProfile = userProfileContent.data
                        let userFullNameLabel = self?.getUserFullNameLabel()
                        userFullNameLabel?.text = userProfile.fullName

                        let userProfileImageView = self?.getUserProfileImageView()
                        userProfileImageView?.load(url: userProfile.profileImageUrl)

                    }.onError { [weak self] error in
                        self?.showErrorSnackbar(message: error)
                    }
                }
            )
    }

    private func getUserFullNameLabel() -> UILabel? {
        return greetingCard.viewWithTag(HomepageViewContoller.USER_FULL_NAME_ID) as? UILabel
    }

    private func getUserProfileImageView() -> UIImageView? {
        return greetingCard.viewWithTag(HomepageViewContoller.USER_PROFILE_IMAGE_ID) as? UIImageView
    }

    deinit {
        if let enrollNotificationObserver = enrollNotificationObserver {
            NotificationCenter.default.removeObserver(enrollNotificationObserver)
        }
    }
}
