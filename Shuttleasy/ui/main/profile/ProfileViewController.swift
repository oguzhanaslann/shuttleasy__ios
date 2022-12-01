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

class ProfileViewController: BaseViewController {

    private let profileBackgroundView : UIView = {
        let stackView  = UIView()
        stackView.backgroundColor = primaryContainer
        return stackView
    }()

    private let profileImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.layer.borderWidth = 4
        imageView.layer.borderColor = backgroundColor.cgColor
        imageView.contentMode = .scaleAspectFill
        imageView.layer.backgroundColor = UIColor.gray.cgColor
        return imageView
    }()
    
    private let profileTitle : UILabel = {
        let label = TitleMedium(text: "Profile")
        return label
    }()

    private let profileName : UILabel = {
        let label = HeadlineSmall(text: "Oğuzhan Aslan")
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(profileImageView)
        profileImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(122)
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
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalTo(profileImageView.snp.centerY)
        }

        view.bringSubviewToFront(profileImageView)
        
        let penIcon : UIImageView =  systemImage(systemName : "pencil")
        penIcon.tintColor = .black
        view.addSubview(penIcon)
        penIcon.snp.makeConstraints { make in
            make.top.equalTo(profileBackgroundView.snp.top).offset(60)
            make.right.equalTo(profileBackgroundView.snp.right).offset(-16)
            make.width.equalTo(24)
            make.height.equalTo(24)
        }
        
        view.addSubview(profileTitle)
        profileTitle.snp.makeConstraints { make in
            make.top.equalTo(profileBackgroundView.snp.top).offset(60)
            make.centerX.equalToSuperview()
        }
        
    }
}
