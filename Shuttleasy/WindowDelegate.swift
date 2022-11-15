//
//  WindowDelegate.swift
//  Shuttleasy
//
//  Created by Oğuzhan Aslan on 13.11.2022.
//

import Foundation
import UIKit

class WindowDelegate {
    var window: UIWindow?
    static let shared = WindowDelegate()
    private var navController : UINavigationController? = nil
    
    func setRootViewController(rootViewController : UIViewController?) {
        if window?.rootViewController != nil {
            setWindowRootContollerWithAnimation(rootViewController: rootViewController)
        } else {
            setWindowRootController(rootViewController: rootViewController)
        }
    }
    
    func setRootViewController(navController : UINavigationController?) {
        self.navController = navController
        if window?.rootViewController != nil {
            setWindowRootContollerWithAnimation(rootViewController: navController)
        } else {
            setWindowRootController(rootViewController: navController)
        }
    }
    
    func popBackstack(animated : Bool = false) {
        if navController == nil {
            print("WindowDelegate - popBackstack - navcontroller is empty")
        }
        navController?.popViewController(animated: animated)
    }
    
    func pushViewController(_ viewController: UIViewController, animated : Bool = false ) {
        navController?.pushViewController(viewController, animated: animated)
    }
    
    private func setWindowRootContollerWithAnimation(rootViewController : UIViewController?) {
        UIView.transition(
            from: window!.rootViewController!.view,
            to: rootViewController!.view,
            duration: 0.3,
            options: [.transitionCrossDissolve],
            completion: {
            _ in
                self.setWindowRootController(rootViewController: rootViewController)
        })
    }
    
    private func setWindowRootController(rootViewController : UIViewController?) {
        window?.rootViewController = rootViewController
        window?.makeKeyAndVisible()
    }
}
