//
//  EmptySessionCell.swift
//  Shuttleasy
//
//  Created by OguzhanMac on 6.05.2023.
//

import Foundation
import UIKit
import Lottie

class EmptySessionCell : BaseTableViewCell {

    static let identifier  = "EmptySessionCell"

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initViews()
    }
    
    private func initViews() {
        var lottieView : LottieAnimationView? = nil
        let descriptionLabel = TitleMedium(text : Localization.noResultFound.localized)
        if let file = getLottieFile() {
            lottieView = LottieAnimationView(filePath: file)
            lottieView!.loopMode = .loop
            lottieView!.play()
            contentView.addSubview(lottieView!)
            contentView.addSubview(descriptionLabel)
        }

        contentView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.greaterThanOrEqualTo(180 + 36 + SpacingSmall + SpacingLarge)
        }
        
        if let lottieView = lottieView {
            lottieView.snp.makeConstraints { make in
                make.size.lessThanOrEqualTo(180)
                make.top.equalToSuperview().offset(SpacingLarge)
                make.centerX.equalToSuperview()
            }
            
            descriptionLabel.snp.makeConstraints { make in
                make.top.equalTo(lottieView.snp.bottom).offset(SpacingSmall)
                make.centerX.equalToSuperview()
                make.height.lessThanOrEqualTo(36)
                descriptionLabel.breakLineFromEndIfNeeded()
            }
        }
        
        
 
    }
    
    func getLottieFile() -> String? {
        guard let file = Bundle.main.path(forResource: driverEmptyLottie, ofType: "json") else { return nil }
        return file
    }
    
}
