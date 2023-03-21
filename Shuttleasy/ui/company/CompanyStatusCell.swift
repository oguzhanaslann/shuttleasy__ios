//
//  CompanyStatusCell.swift
//  Shuttleasy
//
//  Created by OguzhanMac on 27.02.2023.
//

import Foundation
import UIKit

class CompanyStatusCell : UITableViewCell {
    
    public static let identifier = "CompanyStatusCell"
    
    
    private static let STATUS_LABEL_TAG_MEMBERSHIP = 39139
    private static let STATUS_TEXT_TAG_MEMBERSHIP = 24473
    
    private static let STATUS_LABEL_TAG_SHUTTLE_COUNT = 61559
    private static let STATUS_TEXT_TAG_SHUTTLE_COUNT = 80681
    
    
    let statView = statusView(
        icon: systemImage(systemName: "clock"),
        statusLabel: Localization.membership.localized,
        statusText: "",
        statusLabelTag: CompanyStatusCell.STATUS_LABEL_TAG_MEMBERSHIP,
        statusTextTag: CompanyStatusCell.STATUS_TEXT_TAG_MEMBERSHIP
    )
    let statView2 = statusView(
        icon: systemImage(systemName: "bus"),
        statusLabel: Localization.shuttles.localized,
        statusText: "",
        statusLabelTag: CompanyStatusCell.STATUS_LABEL_TAG_SHUTTLE_COUNT,
        statusTextTag: CompanyStatusCell.STATUS_TEXT_TAG_SHUTTLE_COUNT
        
    )
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        transparentBackground()
        
        addSubview(statView)
        addSubview(statView2)
        
        statView.snp.makeConstraints { make in
            make.width.equalTo(156)
            make.height.equalTo(96)
            make.left.equalToSuperview().offset(24)
            make.top.equalToSuperview().offset(16)
            make.bottom.lessThanOrEqualToSuperview()
        }
        
        statView2.snp.makeConstraints { make in
            make.width.equalTo(156)
            make.height.equalTo(96)
            make.left.equalTo(statView.snp.right).offset(16)
            make.top.equalToSuperview().offset(16)
            make.right.lessThanOrEqualToSuperview()
        }
    }
    
    
    private static func statusView(
        icon: UIImageView,
        statusLabel: String,
        statusText : String,
        statusLabelTag: Int? = nil,
        statusTextTag: Int? = nil
    )  -> UIView{
        let statView = UIView()
        statView.layer.cornerRadius = 16
        statView.backgroundColor = secondaryContainer
        statView.layer.borderColor = outline.cgColor
        statView.layer.borderWidth = 1
        
        let clockIcon = icon
        clockIcon.tintColor = onSecondaryContainer
        statView.addSubview(clockIcon)
        clockIcon.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.left.equalToSuperview().inset(16)
        }
        
        let statusLabel = LabelSmall(text: statusLabel, color : onSecondaryContainer)
        statView.addSubview(statusLabel)
        statusLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(18)
            make.left.equalTo(clockIcon.snp.right).offset(8)
            make.right.lessThanOrEqualToSuperview()
        }

        if let statusLabelTag = statusLabelTag {
            statusLabel.tag = statusLabelTag
        }
        
        
        let head = HeadlineSmall(text: statusText, color : onSecondaryContainer)
        statView.addSubview(head)
        head.snp.makeConstraints { make in
            make.top.greaterThanOrEqualTo(clockIcon.snp.bottom).offset(8)
            make.left.equalToSuperview().offset(16)
            make.right.lessThanOrEqualToSuperview().offset(-16)
        }

        if let statusTextTag = statusTextTag {
            head.tag = statusTextTag
        }
        
        return statView
    }
    
    func initialize(with companyDetail : CompanyDetail?) {
        let membershipText = getMembershipText()
        membershipText?.text = companyDetail?.membershipDate
        
        let shuttleCountText = getShuttleCountText()
        shuttleCountText?.text = String(companyDetail?.shuttleCount ?? 0)
        layoutSubviews()
    }

    private func getMembershipText() -> UILabel? {
        return viewWithTag(CompanyStatusCell.STATUS_TEXT_TAG_MEMBERSHIP) as? UILabel
    }

    private func getShuttleCountText() -> UILabel? {
        return viewWithTag(CompanyStatusCell.STATUS_TEXT_TAG_SHUTTLE_COUNT) as? UILabel
    }
}
