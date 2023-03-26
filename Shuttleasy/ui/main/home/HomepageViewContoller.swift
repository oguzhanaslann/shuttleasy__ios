//
//  HomepageViewContoller.swift
//  Shuttleasy
//
//  Created by Oğuzhan Aslan on 30.11.2022.
//

import UIKit

class HomepageViewContoller: BaseViewController {
    
    private var enrollNotificationObserver: NSObjectProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = Localization.home.localized
        
        subscribeToEnrollNotification()
    }

    private func subscribeToEnrollNotification() {
       enrollNotificationObserver = NotificationCenter.default.addObserver(
            forName: notificationNamed(.enrolled),
            object: nil,
            queue: .main
        ) { [weak self] notification in
            // Handle the notification
            print("Enrolled to shuttle")
        }
    }


    deinit {
        if let enrollNotificationObserver = enrollNotificationObserver {
            NotificationCenter.default.removeObserver(enrollNotificationObserver)
        }
    }
}
