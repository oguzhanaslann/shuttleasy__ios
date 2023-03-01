//
//  CompanyShuttlesCell.swift
//  Shuttleasy
//
//  Created by OguzhanMac on 1.03.2023.
//

import Foundation
import UIKit

class CompanyShuttleCell: UITableViewCell {
    static let identifier = "CompanyShuttleCell"
    
    let foo = LabelLarge(text: "Label", color : onBackgroundColor)
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        transparentBackground()
        addSubview(foo)
        foo.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
        }
    }
    
}
