//
//  AppDelegate.swift
//  Shuttleasy
//
//  Created by Oğuzhan Aslan on 14.10.2022.
//

import UIKit
import PopupDialog

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    let injector = Injector.shared
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        setUpPopupDialogAppereance()
        
        let appRepository = injector.injectAppRepository()
        appRepository.initApplication()
        return true
    }
    
    func setUpPopupDialogAppereance() {
        let containerAppearance = PopupDialogContainerView.appearance()

        containerAppearance.backgroundColor = backgroundColor
        containerAppearance.cornerRadius = Float(SHAPE_MEDIUM)
        
        let dialogAppearance = PopupDialogDefaultView.appearance()
        dialogAppearance.backgroundColor = backgroundColor
        dialogAppearance.titleFont = TitleMediumFont()
        dialogAppearance.titleColor = onBackgroundColor
        dialogAppearance.titleTextAlignment = .center
        dialogAppearance.messageFont = BodyMediumFont()
        dialogAppearance.messageColor = onBackgroundColor.withAlphaComponent(0.6)
        dialogAppearance.messageTextAlignment = .center
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}
