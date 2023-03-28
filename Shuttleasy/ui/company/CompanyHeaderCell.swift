//
//  CompanyHeaderCell.swift
//  Shuttleasy
//
//  Created by OguzhanMac on 27.02.2023.
//

import Foundation
import UIKit

class CompanyHeaderCell : BaseTableViewCell {
    
    public static let identifier = "CompanyHeaderCell"
    private static let HEADER_TITLE_LABEL_TAG = 61781
    
    let contactHeader = sectionHeader(textTag: HEADER_TITLE_LABEL_TAG)
 
    
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
    
    func setTitle(_ title: String) {
        let label = self.contactHeader.viewWithTag(CompanyHeaderCell.HEADER_TITLE_LABEL_TAG) as? UILabel
        if let titleView = label {
            titleView.text = title
        }
    }
}
