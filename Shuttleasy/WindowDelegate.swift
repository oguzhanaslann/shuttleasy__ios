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
    
    func setRootViewController(rootViewController : UIViewController?) {
        if window?.rootViewController != nil {
            setWindowRootContollerWithAnimation(rootViewController: rootViewController)
        } else {
            setWindowRootController(rootViewController: rootViewController)
        }
       
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
