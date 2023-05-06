//
//  PermissionViewController.swift
//  Shuttleasy
//
//  Created by OguzhanMac on 1.05.2023.
//

import Foundation
import UIKit
import SnapKit

struct PermissionModel {
    let iconResImage: String
    let description: String
    let actionTitle : String
}

class  PermissionViewController : BaseViewController {
    
    private static let ICON_TAG = 0
    
    private let container = UIView()
    
    lazy var notificationIconView : UIView = {
        let container = UIView()
        container.backgroundColor = inversePrimary
        container.snp.makeConstraints { make in
            make.width.height.equalTo(124)
        }
        container.layer.cornerRadius = 62
        container.layer.masksToBounds = true
        return container
    }()
    
    private func getIconView() -> UIImageView? {
        return notificationIconView.viewWithTag(PermissionViewController.ICON_TAG) as? UIImageView
    }
    
    let descriptionLabel = TitleLarge(color : onPrimaryContainer)
    
    let permissionButton = LargeButton(titleOnNormalState: Localization.enable.localized)
    
    private let args : PermissionModel
    
    init(args : PermissionModel){
        self.args = args
        super.init(nibName: nil, bundle: nil)
    }
       
    required init(coder : NSCoder){
        fatalError()
    }

    
    override func viewDidLoad() {
        view.backgroundColor = primaryContainer
        view.addSubview(container)
    
        container.addSubview(notificationIconView)
        notificationIconView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
        }

        let imageView = resImageView(name: args.iconResImage)
        notificationIconView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(48)
        }
        
        imageView.tag = PermissionViewController.ICON_TAG

        container.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(notificationIconView.snp.bottom).offset(SpacingMedium)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-SpacingMedium)
        }
        descriptionLabel.text = args.description
        descriptionLabel.textAlignment = .center
        descriptionLabel.breakLineFromEndIfNeeded()

        container.addSubview(permissionButton)
        permissionButton.setTitle(args.actionTitle, for: .normal)
        permissionButton.snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(largeButtonHeight)
            make.top.equalTo(descriptionLabel.snp.bottom).offset(SpacingMedium)
            make.centerX.equalToSuperview()
            make.width.greaterThanOrEqualTo(124)
        }
        
        
        container.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview().offset(-16)
            make.height.greaterThanOrEqualTo(300)
        }
        
    }
    
    override func shouldSetStatusBarColor() -> Bool {
        return false
    }
    
    override func getStatusBarColor() -> UIColor {
        return .clear
    }
    
    override func getNavigationBarTintColor() -> UIColor {
        return .clear
    }
    
}
