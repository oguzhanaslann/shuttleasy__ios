//
//  BaseViewController.swift
//  Shuttleasy
//
//  Created by Oğuzhan Aslan on 13.11.2022.
//

import Foundation
import UIKit

class BaseViewController: UIViewController,UIGestureRecognizerDelegate {
    
    private var statusBarView : UIView? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = backgroundColor
        setStatusBarColorByOrientationIfNeeded()
        setNavigationBarTheme()
    }
    
    private func setStatusBarColorByOrientationIfNeeded() {
        if shouldSetStatusBarColor() {
           setStatusBarColorByDeviceOrientation()
        }
    }
    
    func shouldSetStatusBarColor() -> Bool {
        return true
    }
    
    private func setStatusBarColorByDeviceOrientation() {
        if UIDevice.current.orientation.isLandscape {
            if statusBarView != nil && view.subviews.contains(statusBarView!) {
                statusBarView!.removeFromSuperview()
            }
        } else {
            setStatusBarColorIfNotSet()
        }
    }
    
    
    final func setStatusBarColorIfNotSet() {
          if statusBarView == nil  {
              statusBarView = UIView(frame: getStatusbarHeight())
              statusBarView!.backgroundColor = getStatusBarColor()
          }

          if view.subviews.contains(statusBarView!).not() {
              view.addSubview(statusBarView!)
          }
      }
    
    
    func getStatusBarColor() -> UIColor {
        return primaryContainer
    }
    
    func getStatusbarHeight() -> CGRect {
        return UIApplication.shared.statusBarFrame
    }
    
    final func setNavigationBarTheme() {
        navigationController?.navigationBar.backgroundColor = getNavigationBarBackgroundColor()
        navigationController?.navigationBar.tintColor = getNavigationBarTintColor()
        navigationController?.navigationBar.titleTextAttributes = getNavigationBarTitleStyle()
    }
    
    func getNavigationBarBackgroundColor() -> UIColor {
        return primaryContainer
    }

    func getNavigationBarTintColor() -> UIColor {
        return onPrimaryContainer
    }
    
    func getNavigationBarTitleStyle(
        titleColor : UIColor = onPrimaryContainer,
        font : UIFont  = LabelLargeFont(16)
    ) -> [NSAttributedString.Key: NSObject] {
        let textAttributes = [
            NSAttributedString.Key.foregroundColor: titleColor,
            NSAttributedString.Key.font: LabelLargeFont(16)
        ]
        
        return textAttributes
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        setStatusBarColorByOrientationIfNeeded()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        statusBarView = nil
    }   
}
