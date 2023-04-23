//
//  SessionDetailViewController.swift
//  Shuttleasy
//
//  Created by OguzhanMac on 18.04.2023.
//

import Foundation
import UIKit
import SnapKit

class SessionDetailViewController: BaseViewController {
    
    let sessionStateView = SessionStateView()
    
    override func viewDidLoad() {
        title = Localization.yourRide.localized
        view.backgroundColor = .gray

        view.addSubview(sessionStateView)
        sessionStateView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            make.right.equalToSuperview().offset(-16)
            sessionStateView.layoutIfNeeded()
        }
        
        view.bringSubviewToFront(sessionStateView)

        sessionStateView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapSessionStateView)))
    }

    @objc func didTapSessionStateView() {
        let sessionState = SessionState.completed
        sessionStateView.setState(state: sessionState)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavBackButton(navigationItem: navigationItem, target: self, action: #selector(dismissView))
    }
    
    @objc func dismissView() {
        Navigator.shared.popBack(from: self)
    }
}
