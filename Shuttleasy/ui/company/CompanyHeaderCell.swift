//
//  CompanyHeaderCell.swift
//  Shuttleasy
//
//  Created by OguzhanMac on 27.02.2023.
//

import Foundation
import UIKit

class CompanyHeaderCell : UITableViewCell {
    
    public static let identifier = "CompanyHeaderCell"
    
    let contactHeader = sectionHeader(title: "Contact")
 
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.addSubview(contactHeader)
        contactHeader.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview()
            make.height.greaterThanOrEqualTo(48)
        }
    }
}
