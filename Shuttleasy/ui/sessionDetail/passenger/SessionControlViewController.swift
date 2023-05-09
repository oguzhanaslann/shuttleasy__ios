//
//  SessionControlViewController.swift
//  Shuttleasy
//
//  Created by OguzhanMac on 23.04.2023.
//

import Foundation
import UIKit
import Combine

class SessionControllerViewController: BaseViewController {

    private static let DESTINATION_TITLE_TAG = 1
    private static let START_TIME_TITLE_TAG = 3

    private let viewModel : SessionDetailViewModel
    private var sessionDetailObserver : AnyCancellable? = nil

    let plateNumber = TitleMedium()
        
    let destinationLabel = createCardSection(
        title: "",
        subtitle: Localization.destination.localized,
        resImageName: "icCity",
        titleTag: DESTINATION_TITLE_TAG
    )
    
    let dateLabel = createCardSection(
        title: "",
        subtitle: Localization.startTime.localized,
        resImageName: "icCalendar",
        titleTag: START_TIME_TITLE_TAG
    )
    
    let button = LargeButton(
        titleOnNormalState: Localization.wait5Minutes.localized,
        buttonColors: outlinedButtonColors()
    )
    
    
    let cancelButton = LargeButton(
        titleOnNormalState: Localization.cancelMySession.localized,
        buttonColors: errorTextButtonColors()
    )
    
    
    init(viewModel : SessionDetailViewModel){
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
       
    required init(coder : NSCoder){
        fatalError()
    }
    
    override func viewDidLoad() {
        
        view.addSubview(plateNumber)
        plateNumber.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.left.equalToSuperview().offset(24)
            make.right.lessThanOrEqualToSuperview().offset(-24)
        }

        view.addSubview(destinationLabel)
        destinationLabel.snp.makeConstraints { make in
            make.top.equalTo(plateNumber.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
            make.height.greaterThanOrEqualTo(34)
        }
        
        view.addSubview(dateLabel)
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(destinationLabel.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
            make.height.greaterThanOrEqualTo(34)
        }
        

        view.addSubview(button)
        button.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(24)
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
            make.height.equalTo(largeButtonHeight)
        }

        view.addSubview(cancelButton)
        cancelButton.snp.makeConstraints { make in
            make.top.equalTo(button.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
            make.height.equalTo(largeButtonHeight)
        }
        
        subscribeObservers()
    }

    // get destination title view 
    private func getDestinationTitleView() -> UILabel {
        return destinationLabel.viewWithTag(SessionControllerViewController.DESTINATION_TITLE_TAG) as! UILabel
    }

    // get start time title view
    private func getStartTimeTitleView() -> UILabel {
        return dateLabel.viewWithTag(SessionControllerViewController.START_TIME_TITLE_TAG) as! UILabel
    }
    
    private func subscribeObservers() {
        sessionDetailObserver = viewModel.sessionDetailPublisher
            .receive(on: DispatchQueue.main)
            .sink (
                receiveCompletion: { _ in},
                receiveValue: {[weak self] sessionDetailDataState in
                    sessionDetailDataState.onSuccess {
                        let sessionDetail = $0.data.sessionDetail
                        self?.setDestinationName(sessionDetail)
                        self?.setStartTime(sessionDetail)
                        self?.plateNumber.text = sessionDetail.vehiclePlateNumber
                        
                        let sessionState = $0.data.sessionState
                        self?.updateSessionDetailBy(sessionState: sessionState)
                    }
                }
        )
    }

    private func updateSessionDetailBy(sessionState: SessionState) {
        cancelButton.isEnabled = sessionState.isCancellable()
        button.isEnabled = sessionState.canBeExtendable()
    }
    
    private func setDestinationName(_ sessionDetail: SessionDetail) {
        getDestinationTitleView().text = sessionDetail.destinationName
    }

    private func setStartTime(_ sessionDetail: SessionDetail) {
        getStartTimeTitleView().text = ShuttleasyDateFormatter.shared.convertDate(
            date: sessionDetail.startTime,
            targetFormat: ShuttleasyDateFormatter.timeAndCalendarDateFormat()
        )
    }
    
    override func shouldSetStatusBarColor() -> Bool {
        return false
    }
    
    override func getNavigationBarTintColor() -> UIColor {
        return .clear
    }
    
    override func getStatusBarColor() -> UIColor {
        return .clear
    }
}
