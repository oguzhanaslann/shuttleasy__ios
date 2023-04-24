//
//  SessionControlViewController.swift
//  Shuttleasy
//
//  Created by OguzhanMac on 23.04.2023.
//

import Foundation
import UIKit

class SessionControllerViewController: BaseViewController {
    
    override func viewDidLoad() {
        let plateNumber = TitleMedium(text: "35YU3436")
        view.addSubview(plateNumber)
        plateNumber.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.left.equalToSuperview().offset(24)
            make.right.lessThanOrEqualToSuperview().offset(-24)
        }

        let destinationLabel = createCardSection(
            title: "Istanbul",
            subtitle: Localization.destination.localized, 
             resImageName: "icCity"
        )
        
        view.addSubview(destinationLabel)
        destinationLabel.snp.makeConstraints { make in
            make.top.equalTo(plateNumber.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
            make.height.greaterThanOrEqualTo(34)
        }
        
        let dateLabel = createCardSection(
            title: "23.04.2023",
            subtitle: Localization.startTime.localized,
            resImageName: "icCalendar"
        )
        
        view.addSubview(dateLabel)
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(destinationLabel.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
            make.height.greaterThanOrEqualTo(34)
        }
        
        let button = LargeButton(
            titleOnNormalState: Localization.wait5Minutes.localized,
            buttonColors: outlinedButtonColors()
        )
        view.addSubview(button)
        button.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(24)
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
            make.height.equalTo(largeButtonHeight)
        }
        
        button.isEnabled = false

        let cancelButton = LargeButton(
            titleOnNormalState: Localization.cancelMySession.localized,
            buttonColors: errorTextButtonColors()
        )

        view.addSubview(cancelButton)
        cancelButton.snp.makeConstraints { make in
            make.top.equalTo(button.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
            make.height.equalTo(largeButtonHeight)
        }
        
        cancelButton.isEnabled = false
        
    }
    
    override func shouldSetStatusBarColor() -> Bool {
        return false
    }
    
    override func getNavigationBarTintColor() -> UIColor {
        return .clear
    }
    
    override func getStatusBarColor() -> UIColor {
        return .clear
    }
}
