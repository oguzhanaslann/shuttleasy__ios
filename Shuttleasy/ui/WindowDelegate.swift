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
    
    func pushViewController(_ viewController: UIViewController, animated : Bool = false, singleTop : Bool = false) {
        if (singleTop) {
            let isInBackStack  = navController?.viewControllers.filter({$0.isKind(of: type(of: viewController))}).count ?? 0 > 0
            if (isInBackStack) {
                // index of 
                let index = navController?.viewControllers.firstIndex(where: {$0.isKind(of: type(of: viewController))})
                navController?.viewControllers.remove(at: index!)
            }
        }
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
    
    func setApplicationUIStyle(style selected: UIUserInterfaceStyle) {
        UIApplication.shared.windows.forEach { window in
                if #available(iOS 13.0, *) {
                    window.overrideUserInterfaceStyle = selected
                    DispatchQueue.main.async {
                        window.layoutIfNeeded()
                    }
                } else {
                    // Fallback on earlier versions
                    // Earlier versions of iOS don't support dark mode, so we don't need to do anything here.
                    // if needed you need to implement it manually
                }
            }
    }
}
