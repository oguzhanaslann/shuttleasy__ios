//
//  WindowDelegate.swift
//  Shuttleasy
//
//  Created by Oğuzhan Aslan on 13.11.2022.
//

import Foundation
import UIKit

class WindowDelegate {
    static let shared = WindowDelegate()
    private init() {}
    
    var window: UIWindow?

    func popBackstack(from: UIViewController, isPresented: Bool, animated : Bool = false) {
        if isPresented {
            from.dismiss(animated: true, completion: nil)
        } else {
            from.navigationController?.popViewController(animated: animated)
        }
    }
    
    func pushViewController(from : UIViewController , to viewController: UIViewController, animated : Bool = true, singleTop : Bool = false) {
        if let navController = from.navigationController {
            pushViewControllerOn(navController, viewController)
        } else {
            viewController.modalPresentationStyle = .fullScreen
            from.present(viewController, animated: animated)
        }
    }

    private func pushViewControllerOn(_ navController: UINavigationController, _ viewController: UIViewController, animated : Bool = true, singleTop : Bool = false) {
        if (singleTop) {
            let isInBackStack  = navController.viewControllers.filter({$0.isKind(of: type(of: viewController))}).count > 0
            if (isInBackStack) {
                // index of
                let index = navController.viewControllers.firstIndex(where: {$0.isKind(of: type(of: viewController))})
                navController.viewControllers.remove(at: index!)
            }
        }
        navController.pushViewController(viewController, animated: animated)
    }
    
   
    func changeWindow(controller: UIViewController) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            UIApplication.shared.windows.first?.rootViewController = controller
            UIApplication.shared.windows.first?.makeKeyAndVisible()
            return
        }
       
        window?.rootViewController = controller
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
