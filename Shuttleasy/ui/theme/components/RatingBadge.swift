//
//  RatingBadge.swift
//  Shuttleasy
//
//  Created by OguzhanMac on 19.03.2023.
//

import Foundation
import UIKit

func ratingBadgeView(
    rating: Double,
    totalRatings: Int,
    backgroundColor : UIColor = primaryColor,
    tintColor : UIColor = onPrimaryColor,
    cornerRadius: CGFloat = 12,
    ratingsTag : Int? = nil
) -> UIView {
    let badge = UIView()
    badge.backgroundColor = backgroundColor
    badge.clipsToBounds = true
    badge.layer.cornerRadius = cornerRadius

    let starIcon = UIImage(systemName: "star.fill")?.withRenderingMode(.alwaysTemplate)
    let starImageView = UIImageView(image: starIcon)
    starImageView.tintColor = tintColor
    badge.addSubview(starImageView)
    starImageView.snp.makeConstraints { make in
        make.left.equalToSuperview().inset(8)
        make.size.equalTo(14)
        make.centerY.equalToSuperview()
    }

    let ratings = LabelMedium(text: "\(rating)(\(totalRatings))", color: tintColor)
    badge.addSubview(ratings)
    ratings.snp.makeConstraints { make in
        make.left.equalTo(starImageView.snp.right).offset(8)
        make.centerY.equalToSuperview()
    }

    if let ratingsTag = ratingsTag {
        ratings.tag = ratingsTag
    }

    return badge
}
