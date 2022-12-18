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
