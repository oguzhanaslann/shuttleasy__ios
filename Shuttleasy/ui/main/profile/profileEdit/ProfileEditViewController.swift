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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let button = UIButton()
    
        view.addSubview(profileImageView)
        profileImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(122)
            make.centerX.equalToSuperview()
            let dimensions = 122
            make.width.equalTo(dimensions)
            make.height.equalTo(dimensions)
            profileImageView.layer.cornerRadius = CGFloat((dimensions / 2))
        }

        // put add new photo view to the right bottom of the profile image view
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
        
        // put go back icon to the top left corner of the screen with 24 padding and top should be same as profile title
        view.addSubview(goBackIcon)
        goBackIcon.snp.makeConstraints { make in
            make.top.equalTo(profileTitle.snp.top)
            make.left.equalToSuperview().offset(24)
            make.width.equalTo(28)
            make.height.equalTo(28)
        }
    
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
