//
//  SearchResultCell.swift
//  Shuttleasy
//
//  Created by Oğuzhan Aslan on 19.12.2022.
//

import Foundation
import UIKit

class SearchResultCell : BaseTableViewCell {

    static let identifier = "SearchResultCell"

    let cardContainer = UIView()
    let resultImage = UIImageView()
    let title = TitleSmall(text: "", color: onSurfaceVariant)
    
    let badgeView = ratingBadgeView(
        rating: 0.0,
        totalRatings: 0,
        ratingsTag: ratingLabel
    )
    
    private static let ratingLabel: Int = 1231

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.backgroundColor = surfaceColor
            
        self.contentView.addSubview(cardContainer)
        cardContainer.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(24)
            make.top.bottom.equalToSuperview().inset(8)
            make.height.equalTo(240)
        }
        cardContainer.backgroundColor = surfaceVariant
        cardContainer.layer.cornerRadius = roundedMediumCornerRadius
        cardContainer.layer.masksToBounds = true
      
        cardContainer.addSubview(resultImage)
        resultImage.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(124)
        }
        
        resultImage.layer.backgroundColor = UIColor.gray.cgColor

        cardContainer.addSubview(title)
        title.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalTo(resultImage.snp.bottom).offset(20)
        }
        
        
        badgeView.layer.maskedCorners = [
            .layerMinXMinYCorner,
            .layerMinXMaxYCorner
        ]
        
        
        cardContainer.addSubview(badgeView)
        
        badgeView.snp.makeConstraints { make in
            make.height.equalTo(30)
            make.width.greaterThanOrEqualTo(108)
            make.centerY.equalTo(resultImage.snp.bottom)
            make.right.lessThanOrEqualToSuperview()
           
        }
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with result: SearchResult) {
        title.text = result.title
        setSearchImageOrDefault(imageUrl: result.imageUrl)
        let ratingLabel = getRatingLabel()
        ratingLabel?.text = "\(result.rating) (\(result.totalRating))"
    }
    
    private func setSearchImageOrDefault(imageUrl: String) {
        if imageUrl.isEmpty {
            let placeholder = UIImage(named: "shuttle_placeholder")
            resultImage.image = placeholder
        } else {
            resultImage.load(url: imageUrl)
        }
        
    }

    // get rating label 
    func getRatingLabel() -> UILabel? {
        return badgeView.viewWithTag(SearchResultCell.ratingLabel) as? UILabel
    }
}
