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
        setStatusBarColorByDeviceOrientation()
        //navigationController?.interactivePopGestureRecognizer?.delegate = self
        setNavigationBarTheme()
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
        navigationController?.navigationBar.tintColor = getNavigationBarTitleColor()
    }
    
    func getNavigationBarBackgroundColor() -> UIColor {
        return primaryContainer
    }

    func getNavigationBarTitleColor() -> UIColor {
        return onPrimaryContainer
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        setStatusBarColorByDeviceOrientation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        statusBarView = nil
    }   
}
