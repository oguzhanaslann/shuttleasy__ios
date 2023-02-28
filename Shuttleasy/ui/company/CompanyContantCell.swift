//
//  CompanyContantCell.swift
//  Shuttleasy
//
//  Created by OguzhanMac on 27.02.2023.
//

import Foundation
import UIKit

class CompanyContentCell : UITableViewCell {
    public static let identifier = "CompanyContentCell"
    
    let phoneRow = sectionRowView(resImageName: "icPhone", value: "1234567890")
    let mailRow = sectionRowView(resImageName: "icMail", value : "sample@sample.com")
    
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let container = UIView()
        
        
        
        container.addSubview(phoneRow)
        phoneRow.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.bottom.lessThanOrEqualToSuperview()
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.height.greaterThanOrEqualTo(24)
        }
        
        container.addSubview(mailRow)
        mailRow.snp.makeConstraints { make in
            make.top.greaterThanOrEqualTo(phoneRow.snp.bottom).offset(16)
            make.bottom.lessThanOrEqualToSuperview()
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.height.greaterThanOrEqualTo(24)
        }
        
        addSubview(container)
        
        container.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
        }
    }
}
