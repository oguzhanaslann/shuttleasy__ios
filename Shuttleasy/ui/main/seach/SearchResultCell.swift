//
//  SearchResultCell.swift
//  Shuttleasy
//
//  Created by Oğuzhan Aslan on 19.12.2022.
//

import Foundation
import UIKit

class SearchResultCell : UITableViewCell {

    static let identifier = "SearchResultCell"

    let cardContainer = UIView()
    let resultImage = UIImageView()
    let title = TitleSmall(text: "", color: onSurfaceVariant)
    let startDateText  = LabelSmall(text: "", color : UIColor.gray)
    let plateNumber = LabelSmall(text: "", color : UIColor.gray)

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
        
        cardContainer.addSubview(plateNumber)
        plateNumber.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(16)
            make.top.equalTo(title.snp.bottom).offset(8)
        }


        cardContainer.addSubview(startDateText)
        startDateText.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(16)
            make.top.equalTo(title.snp.bottom).offset(8)
        }

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with result: SearchResult) {
        title.text = result.title
        resultImage.load(url: result.imageUrl)
        startDateText.text = result.startDateText
        plateNumber.text = result.shutlleBusPlateNumber
    }
}
