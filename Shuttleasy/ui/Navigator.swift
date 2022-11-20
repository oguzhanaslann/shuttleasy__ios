//
//  Navigator.swift
//  Shuttleasy
//
//  Created by Oğuzhan Aslan on 20.11.2022.
//

import Foundation
import UIKit

class Navigator {
        
    static let shared = Navigator()
    
    private init() {}
    
    func navigateToOnboard() {}
    
    func navigateToSignIn(clearBackStack : Bool = false) {
        let SignInViewController = SignInViewController()
        navigateAndClearBackStackIfNeeded(viewController: SignInViewController, clearBackStack: clearBackStack)
    }

    func navigateAndClearBackStackIfNeeded(viewController : UIViewController,clearBackStack : Bool = false) {
        if clearBackStack {
            navigateAndClearBackStack(to: viewController)
        } else {
            navigate(to: viewController, animated: true)
        }        
    }
    
    private func navigate(to viewController: UIViewController, animated : Bool = false) {
        WindowDelegate.shared.pushViewController(viewController,animated : animated) 
    } 

    private func navigateAndClearBackStack(to viewController: UIViewController) {
        let navigationController = UINavigationController(rootViewController: viewController)
        WindowDelegate.shared.setRootViewController(navController: navigationController)
    } 


    func popBack(_ animated : Bool = true) {
        WindowDelegate.shared.popBackstack(animated: animated)
    }

    func navigateToMainpage(clearBackStack : Bool = false) {
        let mainPageViewController = MainViewController()
        navigateAndClearBackStackIfNeeded(viewController: mainPageViewController, clearBackStack: clearBackStack)
    }

    func navigateToEmailPasswordReset(clearBackStack : Bool = false) {
        let emailPasswordResetViewController = EmailPasswordResetController()
        navigateAndClearBackStackIfNeeded(viewController: emailPasswordResetViewController, clearBackStack: clearBackStack)
    }

    func navigateToSignUp(clearBackStack : Bool = false) {
        let signUpViewController = SignUpViewController()
        navigateAndClearBackStackIfNeeded(viewController: signUpViewController, clearBackStack: clearBackStack)    
    }       
}
