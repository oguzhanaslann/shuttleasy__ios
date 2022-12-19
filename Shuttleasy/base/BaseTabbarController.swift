//
//  BaseTabbarController.swift
//  Shuttleasy
//
//  Created by Oğuzhan Aslan on 30.11.2022.
//

import Foundation
import UIKit

class BaseTabBarController: UITabBarController {
    
    private var statusBarView : UIView? = nil
    
    override func viewDidLoad() {
        view.backgroundColor = backgroundColor
        setNavigationBar()
        setStatusBarColorByDeviceOrientation()
    }
    
    
    private func setStatusBarColorByDeviceOrientation() {
        if UIDevice.current.orientation.isLandscape {
            print("Landscape")
            if statusBarView != nil && view.subviews.contains(statusBarView!) {
                statusBarView!.removeFromSuperview()
            }
        } else {
            print("Portrait")
            setStatusBarColorIfNotSet()
        }
    }

    func setStatusBarColorIfNotSet() {
        if statusBarView == nil  {
            statusBarView = UIView(frame: UIApplication.shared.statusBarFrame)
            statusBarView!.backgroundColor = primaryContainer
        }

        if view.subviews.contains(statusBarView!).not() {
            view.addSubview(statusBarView!)
        }
    }
    
    private func setNavigationBar() {
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
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        setStatusBarColorByDeviceOrientation()
    }

    override func viewWillDisappear(_ animated: Bool) {
        statusBarView = nil
    }
    
}
