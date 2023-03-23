//
//  SessionPickCell.swift
//  Shuttleasy
//
//  Created by OguzhanMac on 23.03.2023.
//

import UIKit

class SessionPickCell: UICollectionViewCell {
    
    public static let identifier = "SessionPickCell"
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let timeLabel = LabelMedium(text: "08:00")
        
        addSubview(timeLabel)
        timeLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
        }
    }
}
