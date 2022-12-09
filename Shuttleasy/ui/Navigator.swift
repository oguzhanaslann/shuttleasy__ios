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
    
    func navigateToSignIn(clearBackStack : Bool = false, singleTop :Bool = false, hideNavBar : Bool = false) {
        let SignInViewController = SignInViewController()
        navigateAndClearBackStackIfNeeded(
            viewController: SignInViewController,
            clearBackStack: clearBackStack,
            singleTop: singleTop,
            hideNavBar: hideNavBar
        )
    }

    func navigateAndClearBackStackIfNeeded(
        viewController : UIViewController,
        clearBackStack : Bool = false,
        singleTop :Bool = false,
        hideNavBar : Bool = false
    ) {
        if clearBackStack {
            navigateAndClearBackStack(to: viewController, hideNavBar: hideNavBar)
        } else {
            navigate(to: viewController, animated: true, singleTop: singleTop)
        }        
    }
    
    private func navigate(to viewController: UIViewController, animated : Bool = false, singleTop : Bool = false) {
        WindowDelegate.shared.pushViewController(viewController, animated : animated, singleTop: singleTop)
    } 

    private func navigateAndClearBackStack(to viewController: UIViewController, hideNavBar : Bool = false) {
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.setNavigationBarHidden(hideNavBar, animated: true)
        WindowDelegate.shared.setRootViewController(navController: navigationController)
    } 

    func popBack(_ animated : Bool = true) {
        WindowDelegate.shared.popBackstack(animated: animated)
    }

    func navigateToMainpage(clearBackStack : Bool = false, singleTop :Bool = false, hideNavBar : Bool = false) {
        let mainPageViewController = MainViewController()
        navigateAndClearBackStackIfNeeded(
            viewController: mainPageViewController,
            clearBackStack: clearBackStack ,
            singleTop: singleTop,
            hideNavBar: hideNavBar
        )
    }

    func navigateToEmailPasswordReset(clearBackStack : Bool = false, singleTop :Bool = false, hideNavBar : Bool = false) {
        let emailPasswordResetViewController = EmailPasswordResetController()
        navigateAndClearBackStackIfNeeded(
            viewController: emailPasswordResetViewController,
            clearBackStack: clearBackStack,
            singleTop: singleTop,
            hideNavBar: hideNavBar
        )
    }

    func navigateToSignUp(clearBackStack : Bool = false, singleTop :Bool = false, hideNavBar : Bool = false) {
        let signUpViewController = SignUpViewController()
        navigateAndClearBackStackIfNeeded(
            viewController: signUpViewController, 
            clearBackStack: clearBackStack,
            singleTop: singleTop,
            hideNavBar: hideNavBar
        )    
    }    

    func navigateToResetCode(userEmail: String,clearBackStack : Bool = false, singleTop :Bool = false, hideNavBar : Bool = false) {
        let resetCodeViewController = ResetCodeViewController(userEmail: userEmail)
        navigateAndClearBackStackIfNeeded(
            viewController: resetCodeViewController, 
            clearBackStack: clearBackStack,
            singleTop: singleTop,
            hideNavBar: hideNavBar
        )    
    }   
    
    func navigateToResetPassword(userEmail: String,clearBackStack : Bool = false, singleTop :Bool = false, hideNavBar : Bool = false) {
        let resetPasswordViewController = ResetPasswordViewController(userEmail: userEmail)
        navigateAndClearBackStackIfNeeded(
            viewController: resetPasswordViewController, 
            clearBackStack: clearBackStack,
            singleTop: singleTop,
            hideNavBar: hideNavBar
        )    
    }
    
    
    func navigateToProfileEdit(clearBackStack : Bool = false, singleTop :Bool = false, hideNavBar : Bool = false) {
        let profileEditViewController = ProfileEditViewController()
        navigateAndClearBackStackIfNeeded(
            viewController: profileEditViewController,
            clearBackStack: clearBackStack,
            singleTop: singleTop,
            hideNavBar: hideNavBar
        )    
    }

    func navigateToProfileSetup(clearBackStack : Bool = false, signUpModelShort : SignUpModelShort, singleTop :Bool = false, hideNavBar : Bool = false) {
        let profileSetupViewController = ProfileSetupViewController(signUpModelShort: signUpModelShort)
        navigateAndClearBackStackIfNeeded(
            viewController: profileSetupViewController, 
            clearBackStack: clearBackStack,
            singleTop: singleTop,
            hideNavBar: hideNavBar
        )    
    }
}
