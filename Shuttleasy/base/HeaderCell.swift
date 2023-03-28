//
//  HeaderCell.swift
//  Shuttleasy
//
//  Created by OguzhanMac on 28.03.2023.
//

import Foundation
import UIKit
import SnapKit

class HeaderCell : BaseTableViewCell {
    
    public static let identifier = "HeaderCell"
    
    private static let HEADER_TITLE_LABEL_TAG = 61781
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
            
        contentView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.greaterThanOrEqualTo(48)
        }
        
    }
    
    func setTitle(
        _ title: String,
        inludeDivier : Bool = true
    ) {
        
        let label = sectionHeader(
            title: title,
            textTag: HeaderCell.HEADER_TITLE_LABEL_TAG
        )
        self.addSubview(label)
        label.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview()
            make.height.greaterThanOrEqualTo(48)
        }
    }
}

