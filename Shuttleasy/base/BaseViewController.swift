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
        setStatusBarColorIfNotSet()
        //navigationController?.interactivePopGestureRecognizer?.delegate = self 
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
        return primaryColor
    }
    
    func getStatusbarHeight() -> CGRect {
        return UIApplication.shared.statusBarFrame
    }
}
