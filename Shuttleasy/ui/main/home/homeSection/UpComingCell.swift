//
//  UpComingCell.swift
//  Shuttleasy
//
//  Created by OguzhanMac on 28.03.2023.
//

import Foundation
import UIKit
import SnapKit

class UpComingCell : BaseTableViewCell {
    
    static let identifier = "UpComingCell"
    private static let PLATE_NUMBER_ID = 0
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var nextSessionCard : UIView = {
        let containerCard = UIView()
        containerCard.backgroundColor = surfaceVariant
        containerCard.layer.cornerRadius = roundedLargeCornerRadius
        containerCard.layer.masksToBounds = true
        return containerCard
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initViews()
    }
    
    private func initViews() {
        contentView.addSubview(nextSessionCard)
        nextSessionCard.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
            make.height.equalTo(126)
        }

        contentView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.greaterThanOrEqualTo(126 + 16 + 8)
        }
    }
    
    
    
    func getBadgeView(with text : String) -> UIView{
        let badgeView = UIView()
        badgeView.backgroundColor = inverseSurface
        badgeView.layer.cornerRadius = roundedMediumCornerRadius
        
        let textLabel = LabelSmall(text: text, color: onInverseSurface)
        textLabel.tag = UpComingCell.PLATE_NUMBER_ID
        badgeView.addSubview(textLabel)
        
        textLabel.snp.makeConstraints { make in
            make.left.greaterThanOrEqualToSuperview().offset(8)
            make.right.lessThanOrEqualToSuperview().offset(-8)
            make.top.greaterThanOrEqualToSuperview().offset(4)
            make.bottom.lessThanOrEqualToSuperview().offset(4)
            make.center.equalToSuperview()
        }
        
        return badgeView
    }

    func configure(_ model : UpComingSessionModel) {
        let badgeView = getBadgeView(with: model.sessionBusPlateNumber)
        nextSessionCard.addSubview(badgeView)
        badgeView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.right.equalToSuperview().offset(-16)
            make.height.equalTo(26)
            make.width.equalTo(88)
        }
        
        
        let destinationSection = createCardSection(
            title: model.destinationName,
            subtitle: Localization.destination.localized,
            resImageName: "icCity",
            contentColor: onSurfaceVariant
        )
        
        nextSessionCard.addSubview(destinationSection)
        destinationSection.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(18)
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
            make.height.greaterThanOrEqualTo(34)
        }
        
        
        let startTime = createCardSection(
            title: ShuttleasyDateFormatter.shared.convertDate(
               date:  model.startDate,
               targetFormat: "HH:mm  - dd/MM/yyyy"
            ),
            subtitle: Localization.startTime.localized,
            resImageName: "icCalendar",
            contentColor: onSurfaceVariant
        )

        nextSessionCard.addSubview(startTime)
        startTime.snp.makeConstraints { make in
            make.top.greaterThanOrEqualTo(destinationSection.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
            make.height.greaterThanOrEqualTo(34)
        }
    }
    
    
}

struct UpComingSessionModel {
    let sessionId: Int
    let sessionBusPlateNumber: String
    let destinationName : String
    let startDate: Date
}

