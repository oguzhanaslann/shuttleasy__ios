//
//  SessionStateView.swift
//  Shuttleasy
//
//  Created by OguzhanMac on 23.04.2023.
//

import Foundation
import UIKit

class SessionStateView : UIView {
    
    private let STATE_ICON_TAG = 1
    private let STATE_TEXT_TAG = 2
    
    private var state : SessionState = .nextStopIsYou
    
    private lazy var sessionStateView : UIView = {
        let container = UIView()
        container.layer.cornerRadius = roundedSmallCornerRadius
        container.backgroundColor = .white
        
        let stateIcon = resImageView(name: "ic_oval")
        stateIcon.tag = STATE_ICON_TAG
        container.addSubview(stateIcon)
        stateIcon.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(8)
            make.centerY.equalToSuperview()
            make.width.equalTo(20)
            make.height.equalTo(20)
        }
        

        
        let stateText = LabelSmall()
        stateText.tag = STATE_TEXT_TAG
        container.addSubview(stateText)
        stateText.snp.makeConstraints { make in
            make.left.equalTo(stateIcon.snp.right).offset(8)
            make.right.equalToSuperview().offset(-8)
            make.centerY.equalToSuperview()
        }
        
    
        return container
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureView()
    }
    
    convenience init(state: SessionState) {
        self.init()
        self.state = state
        configureView()
    }

    private func configureView() {
        addSubview(sessionStateView)
        sessionStateView.snp.makeConstraints { make in
            make.width.greaterThanOrEqualTo(132)
            make.height.greaterThanOrEqualTo(36)
        }
        
        self.snp.makeConstraints { make in
            make.width.greaterThanOrEqualTo(132)
            make.height.greaterThanOrEqualTo(36)
        }

        self.updateView()
    }

    func setState(state: SessionState) {
        self.state = state
        updateView()
    }

    private func updateView() {
        let stateIcon = sessionStateView.viewWithTag(STATE_ICON_TAG) as! UIImageView
        let stateText = sessionStateView.viewWithTag(STATE_TEXT_TAG) as! UILabel
        
        switch state {
            case .notStarted:
                stateIcon.tintColor = neutral50
                stateText.textColor = neutral50
                stateText.text = Localization.notStarted.localized
            case .ongoing:
                stateIcon.tintColor = secondaryColor
                stateText.textColor = secondaryColor
                stateText.text = Localization.onGoing.localized
            case .completed:
                stateIcon.tintColor = primaryColor
                stateText.textColor = primaryColor
                stateText.text = Localization.completed.localized
            case .nextStopIsYou:
                stateIcon.tintColor = tertiary
                stateText.textColor = tertiary
                stateText.text = Localization.nextStopIsYou.localized
        }
        
        layoutIfNeeded()
    }
}


enum SessionState {
    case notStarted
    case ongoing
    case completed
    case nextStopIsYou
}
