//
//  BaseTabbarController.swift
//  Shuttleasy
//
//  Created by Oğuzhan Aslan on 30.11.2022.
//

import Foundation
import UIKit

class BaseTabBarController: UITabBarController {
    override func viewDidLoad() {
        view.backgroundColor = backgroundColor
        setNavigationBar()
        setStatusBarColor()
    }

    func setNavigationBar() {
        let appearance = UITabBar.appearance()
        appearance.barTintColor = primaryContainer
        tabBar.layer.backgroundColor = primaryContainer.cgColor
        appearance.tintColor = primaryColor
        appearance.unselectedItemTintColor = onPrimaryContainer
        UITabBarItem.appearance().setTitleTextAttributes(
            [
                NSAttributedString.Key.font: BodySmallFont(),
                NSAttributedString.Key.foregroundColor: onPrimaryContainer
            ],
            for: .normal
        )

         UITabBarItem.appearance().setTitleTextAttributes(
            [
                NSAttributedString.Key.font: BodySmallFont(),
                NSAttributedString.Key.foregroundColor: primaryColor
            ],
            for: .selected
        )
    }

    func setStatusBarColor() {
        
        let statusBarView = UIView(frame: UIApplication.shared.statusBarFrame)
        statusBarView.backgroundColor = primaryContainer
        view.addSubview(statusBarView)

    }
}
