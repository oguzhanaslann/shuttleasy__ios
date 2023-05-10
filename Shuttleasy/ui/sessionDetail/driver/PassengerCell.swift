//
//  PassengerCell.swift
//  Shuttleasy
//
//  Created by OguzhanMac on 9.05.2023.
//

import Foundation
import UIKit
import SnapKit

class PassengerCell : UICollectionViewCell {
    
    static let identifier = "PassengerCell"

    static let itemSize = CGSize(width: 252, height: 252)
    
    var delegate : PassengerCellDelegate? = nil
    
    private var sessionPassenger: SessionPassenger? = nil
    
    private lazy var profilePhoto: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .gray
        image.layer.cornerRadius = 16
        image.snp.makeConstraints { make in
            make.size.equalTo(100)
        }
        return image
    }()
    
    
    private lazy var cardView : UIView = {
        let card = UIView()
        card.snp.makeConstraints { make in
            make.height.equalTo(180)
        }
        card.backgroundColor = .white
        card.layer.cornerRadius = 16
        return card
    }()
    
    private lazy var actionSection: UIView = {
        let container  = UIStackView()
        container.snp.makeConstraints { make in
            make.height.equalTo(58)
        }
        
        let leftView = UIView()
        container.addArrangedSubview(leftView)
        leftView.snp.makeConstraints { make in
            make.height.equalTo(58)
        }

        // left view click listener
        let tapGestureLeft = UITapGestureRecognizer(target: self, action: #selector(onLeftViewClick)) 
        leftView.addGestureRecognizer(tapGestureLeft)
        
        let rightView = UIView()
        container.addArrangedSubview(rightView)
        rightView.snp.makeConstraints { make in
            make.height.equalTo(58)
        }
        
        // right view click listener
        let tapGestureRight = UITapGestureRecognizer(target: self, action: #selector(onRightViewClick))
        rightView.addGestureRecognizer(tapGestureRight)

        let phoneOption = resImageView(name: "icPhone", tint: primaryColor)
        rightView.addSubview(phoneOption)
        phoneOption.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        let tickImage = resImageView(name: "icMail", tint: primaryColor)
        leftView.addSubview(tickImage)
        tickImage.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        let dividerLine = lineView(color: .lightGray)
        container.addSubview(dividerLine)
        dividerLine.snp.makeConstraints { make in
            make.width.equalTo(1)
            make.height.equalToSuperview().offset(-16)
            make.center.equalToSuperview()
        }
        
        container.axis = .horizontal
        container.distribution = .fillEqually
        return container
    }()
    
    @objc func onLeftViewClick() {
        if let passenger = sessionPassenger {
            delegate?.didClickedSendEmail(passenger: passenger)
        }
    }

    @objc func onRightViewClick() {
        if let passenger = sessionPassenger {
            delegate?.didClickedCall(passenger: passenger)
        }
    }

    private let line = lineView(color: .lightGray)
    
    private let personNameLabel = BodySmall()
    
    private let personAddress = LabelSmall(color : neutral50)
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(cardView)
        cardView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }

        contentView.addSubview(profilePhoto)
        profilePhoto.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(24)
            make.bottom.equalTo(cardView.snp.top).offset(50)
        }
        
        cardView.addSubview(actionSection)
        actionSection.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        cardView.addSubview(line)
        line.snp.makeConstraints { make in
            make.width.equalToSuperview().offset(-16)
            make.centerX.equalToSuperview()
            make.height.equalTo(1)
            make.bottom.equalTo(actionSection.snp.top)
        }

        cardView.addSubview(personAddress)
        personAddress.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(24)
            make.bottom.equalTo(line.snp.top).offset(-16)
        }

        cardView.addSubview(personNameLabel)
        personNameLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(24)
            make.bottom.equalTo(personAddress.snp.top).offset(-8)
        }
    }

    func configure(with passenger : SessionPassenger) {
        personNameLabel.text = passenger.passengerName
        personAddress.text = passenger.passengerAddress
        profilePhoto.load(url: passenger.profilePhoto)
        self.sessionPassenger = passenger
    }
}

protocol PassengerCellDelegate {
    func didClickedSendEmail(passenger: SessionPassenger)
    func didClickedCall(passenger: SessionPassenger)
}
