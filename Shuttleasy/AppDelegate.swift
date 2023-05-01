//
//  AppDelegate.swift
//  Shuttleasy
//
//  Created by Oğuzhan Aslan on 14.10.2022.
//

import UIKit
import PopupDialog
import Firebase
import FirebaseMessaging
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate, UNUserNotificationCenterDelegate {
    
    private let injector = Injector.shared
    
    private lazy var appRepository =  {
        let appRepository = self.injector.injectAppRepository()
        return appRepository
    }()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        configureAppNotifications(application: application)
        setUpPopupDialogAppereance()
       
        appRepository.initApplication()
        return true
    }
    
    private func configureAppNotifications(application: UIApplication) {
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert,.badge,.sound]) { [weak self] success, error in
                self?.onNotificationPermissionChange(success: success, error: error)
            }
        application.registerForRemoteNotifications()
    }

    private func onNotificationPermissionChange(success : Bool, error : Error?) {
        guard success == true else {
            return
        }
                
        debugPrint("Permission granted for notifications")
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        messaging.token { [weak self] token, error in
            if let error = error {
                debugPrint("Error fetching FCM registration token: \(error)")
                return
            }
            
            guard let token = token else {
                return
            }

            debugPrint("FCM token: \(token)")
            self?.appRepository.setFcmId(fcmId: token)
        }
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
}
