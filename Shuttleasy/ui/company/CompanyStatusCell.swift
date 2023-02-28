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
    
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let statView = statusView()
        let statView2 = statusView()
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
    
    
    private func statusView()  -> UIView{
        let statView = UIView()
        statView.layer.cornerRadius = 16
        statView.backgroundColor = secondaryContainer
        statView.layer.borderColor = outline.cgColor
        statView.layer.borderWidth = 1
        
        let clockIcon = systemImage(systemName: "clock")
        clockIcon.tintColor = onSecondaryContainer
        statView.addSubview(clockIcon)
        clockIcon.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.left.equalToSuperview().inset(16)
        }
        
        let statusLabel = LabelSmall(text: "Some Label")
        statView.addSubview(statusLabel)
        statusLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(18)
            make.left.equalTo(clockIcon.snp.right).offset(8)
            make.right.lessThanOrEqualToSuperview()
        }
        
        
        let head = HeadlineSmall(text: "2 Yıl")
        statView.addSubview(head)
        head.snp.makeConstraints { make in
            make.top.greaterThanOrEqualTo(clockIcon.snp.bottom).offset(8)
            make.left.equalToSuperview().offset(16)
            make.right.lessThanOrEqualToSuperview().offset(-16)
        }
        
        return statView
    }
}
