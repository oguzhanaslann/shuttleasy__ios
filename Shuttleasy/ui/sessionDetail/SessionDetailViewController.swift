//
//  SessionDetailViewController.swift
//  Shuttleasy
//
//  Created by OguzhanMac on 18.04.2023.
//

import Foundation
import UIKit

class SessionDetailViewController: BaseViewController {
    
    override func viewDidLoad() {
        title = Localization.yourRide.localized
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavBackButton(navigationItem: navigationItem, target: self, action: #selector(dismissView))
    }
    
    @objc func dismissView() {
        Navigator.shared.popBack(from: self)
    }
}
