//
//  SessionPickCell.swift
//  Shuttleasy
//
//  Created by OguzhanMac on 23.03.2023.
//

import UIKit

class SessionPickCell: UICollectionViewCell {
    
    public static let identifier = "SessionPickCell"
    
    private let button = ToggleButton(with: .init())

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(button)
        button.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalTo(42)
            make.width.equalTo(96)
        }
        button.isUserInteractionEnabled = false
    }
    
    func configure(
        with pickModel : SessionPickModel,
        _ gestureRecognizerDelegate: UIGestureRecognizerDelegate? = nil
    ) {
        button.setTitle(pickModel.sessionTitle, for: .normal)
        button.isSelected = pickModel.isSelected
        button.isEnabled = pickModel.isEnabled
    }
}
