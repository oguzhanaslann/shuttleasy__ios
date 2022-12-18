//
//  Navigator.swift
//  Shuttleasy
//
//  Created by Oğuzhan Aslan on 20.11.2022.
//

import Foundation
import UIKit

enum Destination {
    case signIn
    case signUp
    case onboard
    case mainPage
    case emailPasswordReset
    case resetCode(userEmail: String)
    case resetPassword(userEmail: String)
    case profileEdit
    case profileSetup(signUpModelShort: SignUpModelShort)
    case deleteAccount
}

class Navigator {
        
    static let shared = Navigator()
    
    private init() {}
    
    func navigateToOnboard() {}
    
    func navigateToSignIn(from controller: UIViewController, clearBackStack : Bool = false) {
        navigate(from: controller, to: Destination.signIn, clearBackStack: clearBackStack)
    }
    
    func navigateToSignUp(from controller: UIViewController, clearBackStack : Bool = false) {
        navigate(from: controller, to: Destination.signUp, clearBackStack: clearBackStack)
    }
    
    func popBack(from controller: UIViewController, _ animated : Bool = true) {
        WindowDelegate.shared.popBackstack(from: controller, isPresented: false, animated: animated)
    }
        
    func navigateToMainpage(from controller: UIViewController, clearBackStack : Bool = false, singleTop :Bool = false) {
        navigate(from: controller, to: Destination.mainPage, clearBackStack: clearBackStack)
    }

    func navigateToEmailPasswordReset(from controller: UIViewController,clearBackStack : Bool = false, singleTop :Bool = false) {
        navigate(from: controller, to: Destination.emailPasswordReset, clearBackStack: clearBackStack)
    }

    func navigateToResetCode(from controller: UIViewController,userEmail: String,clearBackStack : Bool = false, singleTop :Bool = false) {
        navigate(from: controller, to: Destination.resetCode(userEmail: userEmail), clearBackStack: clearBackStack)
    }   
    
    func navigateToResetPassword(from controller: UIViewController,userEmail: String,clearBackStack : Bool = false, singleTop :Bool = false) {
        navigate(from: controller, to: Destination.resetPassword(userEmail: userEmail), clearBackStack: clearBackStack)
    }
    
    func navigateToProfileEdit(from controller: UIViewController,clearBackStack : Bool = false, singleTop :Bool = false) {
         navigate(from: controller, to: Destination.profileEdit, clearBackStack: clearBackStack)
    }

    func navigateToProfileSetup(from controller: UIViewController,clearBackStack : Bool = false, signUpModelShort : SignUpModelShort, singleTop :Bool = false) {
        navigate(from: controller, to: Destination.profileSetup(signUpModelShort: signUpModelShort), clearBackStack: clearBackStack)
    }

    func navigateToDeleteAccount(from controller: UIViewController,clearBackStack : Bool = false, singleTop :Bool = false) {
        navigate(from: controller, to: Destination.deleteAccount, clearBackStack: clearBackStack)
    }
    
    
    func navigate(from controller: UIViewController, to destination : Destination) {
        WindowDelegate.shared.pushViewController(from: controller, to : destination.controller())
    }
    
    func navigate(from controller: UIViewController, to destination : Destination, clearBackStack: Bool) {
        if clearBackStack {
            WindowDelegate.shared.changeWindow(controller: destination.controller())
        } else {
            navigate(from: controller, to: destination)
        }
    }
}

extension Destination {
    func controller() -> UIViewController {
        switch self {
            case .signIn:
                return SignInViewController()
            case .signUp:
                return SignUpViewController()
            case .onboard:
                return OnBoardingViewContoller()
            case .mainPage:
                return MainViewController()
            case .emailPasswordReset:
                return EmailPasswordResetController()
            case .resetCode(let userEmail):
                return ResetCodeViewController(userEmail: userEmail)
            case .resetPassword(let userEmail):
                return ResetPasswordViewController(userEmail: userEmail)
            case .profileEdit:
                return ProfileEditViewController()
            case .profileSetup(let signUpModelShort):
                return ProfileSetupViewController(signUpModelShort: signUpModelShort)
            case .deleteAccount:
                return DeleteAccountViewController()
            default: 
                debugPrint("Destination not found")
                return UIViewController()
        }
    }    
}



