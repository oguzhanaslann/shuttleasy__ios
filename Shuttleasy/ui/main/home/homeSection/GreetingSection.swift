//
//  GreetingSection.swift
//  Shuttleasy
//
//  Created by OguzhanMac on 28.03.2023.
//

import Foundation
import UIKit
import SnapKit

class GreetionSection : BaseTableViewCell {
    
    static let identifier = "GreetionSection"
    
    private static let USER_PROFILE_IMAGE_ID = 0
    private static let USER_FULL_NAME_ID = 1

    private let greetingCardHeight = 74
    private let topSpacing = 24

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
    
        userFullName.tag = GreetionSection.USER_FULL_NAME_ID
        
        let currentDate = LabelLarge(color: onSurfaceColor)
        container.addSubview(currentDate)
        currentDate.snp.makeConstraints { make in
            make.left.greaterThanOrEqualTo(imageView.snp.right).offset(12)
            make.top.greaterThanOrEqualTo(userFullName.snp.bottom).offset(8)
        }
        
        currentDate.text = ShuttleasyDateFormatter.shared.convertDate(
            date: Date(),
            targetFormat: "\(ShuttleasyDateFormatter.FULL_DAY_NAME), \(ShuttleasyDateFormatter.DAY_OF_THE_MONTH) \(ShuttleasyDateFormatter.MONTH_NAME)"
        )
        
        return container
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initViews()
    }

    private func initViews(){
        contentView.addSubview(greetingCard)
        greetingCard.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(topSpacing)
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
            make.height.equalTo(greetingCardHeight)
        }

        contentView.snp.makeConstraints { make in
            make.height.equalTo(contentHeight())
            make.width.equalToSuperview()
        }
    }
    
    private func contentHeight() -> Int {
        return greetingCardHeight + topSpacing
    }
    
    func configure(_ userProfile : UserProfile) {
        let userFullNameLabel = getUserFullNameLabel()
        userFullNameLabel?.text =  String(
            format: Localization.userGreeting.localized,
            userProfile.fullName
        )

        let userProfileImageView = getUserProfileImageView()
        userProfileImageView?.load(url: userProfile.profileImageUrl)

    }
    
    private func getUserFullNameLabel() -> UILabel? {
        return greetingCard.viewWithTag(GreetionSection.USER_FULL_NAME_ID) as? UILabel
    }

    private func getUserProfileImageView() -> UIImageView? {
        return greetingCard.viewWithTag(GreetionSection.USER_PROFILE_IMAGE_ID) as? UIImageView
    }

}
