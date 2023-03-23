//
//  BaseTableViewCell.swift
//  Shuttleasy
//
//  Created by OguzhanMac on 23.03.2023.
//

import UIKit

class BaseTableViewCell: UITableViewCell {

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureCell()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureCell()
    }
    
    private func configureCell() {
        transparentBackground()
        selectionStyle = .none
    }
    



}
