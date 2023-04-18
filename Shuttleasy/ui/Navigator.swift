//
//  Navigator.swift
//  Shuttleasy
//
//  Created by Oğuzhan Aslan on 20.11.2022.
//

import Foundation
import UIKit
import MapKit

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
    case companyDetail(args: CompanyDetailArgs)
    case pickupSelection(args : PickupSelectionArgs)
    case picksessions(args: PickSessionsArgs)
    case sessionDetail
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
        popBackstack(from: controller, isPresented: false, animated: animated)
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
        pushViewController(from: controller, to : destination.controller())
    }

    func navigate(from controller: UIViewController, to : UIViewController) {
        pushViewController(from: controller, to : to)
    }
    
    func navigate(from controller: UIViewController, to destination : Destination, clearBackStack: Bool) {
        if clearBackStack {
            WindowDelegate.shared.changeWindow(controller: destination.controller())
        } else {
            navigate(from: controller, to: destination)
        }
    }

    func navigate(from controller: UIViewController, to: UIViewController, clearBackStack: Bool) {
        if clearBackStack {
            WindowDelegate.shared.changeWindow(controller: to)
        } else {
            navigate(from: controller, to: to)
        }
    }
    
    func navigate(
        from controller: UIViewController, 
        to destination : Destination, 
        clearBackStack: Bool,
        wrappedInNavigationController: Bool,
        initNavControllerBlock: ((UINavigationController) -> Void)? = nil
    ) {
        var destinationController = destination.controller()

        if wrappedInNavigationController {
            let navigationController = UINavigationController(rootViewController: destinationController)
            if let initNavControllerBlock = initNavControllerBlock {
                initNavControllerBlock(navigationController)
            }
            
            destinationController = navigationController
        }
    
        // change window or present 
        if clearBackStack {
            WindowDelegate.shared.changeWindow(controller: destinationController)
        } else {
            presentViewController(from: controller, to: destinationController, presentedStyle: .fullScreen)
        }
    }
    
    func popBackstack(from: UIViewController, isPresented: Bool, animated : Bool = false) {
        if isPresented {
            from.dismiss(animated: true, completion: nil)
        } else {
            from.navigationController?.popViewController(animated: animated)
        }
    }
    
    func pushViewController(from : UIViewController , to viewController: UIViewController, animated : Bool = true, singleTop : Bool = false) {
        print(from)
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
    
    func presentViewController(
        from: UIViewController, to: UIViewController, presentedStyle: UIModalPresentationStyle
    ) {
        to.modalPresentationStyle = presentedStyle
        from.present(to, animated: true)
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
            case .companyDetail(let args):
                return CompanyDetailViewController(args :args )
            case .pickupSelection(let args):
                return PickupSelectionViewController(args: args)
            case .picksessions(let args):
                return PickSessionsViewController(args: args)
        case .sessionDetail:
                return SessionDetailViewController()
            default: 
                debugPrint("Destination not found")
                return UIViewController()
        }
    }    
}



