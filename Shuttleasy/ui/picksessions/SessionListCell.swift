//
//  SessionListCell.swift
//  Shuttleasy
//
//  Created by OguzhanMac on 22.03.2023.
//

import Foundation
import UIKit
import SnapKit

class SessionListCell : BaseTableViewCell, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    public static let identifier = "SessionListCell"
    
    private static let itemSize = CGSize(width: 96, height: 42)
    
    
    private let dateLabel = TitleLarge()
    
    let line = lineView(color : onBackgroundColor)
    
    private let flowLayout = UICollectionViewFlowLayout()

    let departureSessionsLabel = LabelMedium(text: Localization.departure.localized)
    let departureSessionsTimeCollection : BaseUICollectionView = BaseUICollectionView(
        frame: .zero,
        collectionViewLayout: .init()
    )
    
    let returnSessionsLabel = LabelMedium(text: Localization._return.localized)
    let returnSessionsTimeCollection : BaseUICollectionView = BaseUICollectionView(
        frame: .zero,
        collectionViewLayout: .init()
    )

    private var sessionPickList : [SessionPickModel] = []
    
    private weak var delegate : SessionListCellDelegate? = nil
    
    private var position: Int? =  nil

    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(dateLabel)
        dateLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.left.equalToSuperview().offset(16)
            make.height.equalTo(24)
        }
        
        contentView.addSubview(line)
        line.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(8)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.height.equalTo(1)
        }
    
        flowLayout.scrollDirection = .horizontal
        flowLayout.itemSize = SessionListCell.itemSize
    }
    
    func configure(
        with model: SessionPickListModel
    ) {
        dateLabel.text = model.dayName
        self.sessionPickList = model.sessionPickList
        
        departureSessionsLabel.removeFromSuperview()
        departureSessionsTimeCollection.removeFromSuperview()
        let departures = sessionPickList.filter { $0.isDeparture }
        if !departures.isEmpty {
            putDepartureView()
        }
        
        returnSessionsLabel.removeFromSuperview()
        returnSessionsTimeCollection.removeFromSuperview()
        
        let returns = sessionPickList.filter { !$0.isDeparture }
        if !returns.isEmpty {
            putReturnView(departures: departures)
        }
    
        layoutIfNeeded()
    }
    
    private func putDepartureView() {
        contentView.addSubview(departureSessionsLabel)
        departureSessionsLabel.snp.makeConstraints { make in
            make.top.greaterThanOrEqualTo(line.snp.bottom).offset(12)
            make.left.lessThanOrEqualToSuperview().offset(16)
            make.height.equalTo(24)
        }
        
        departureSessionsTimeCollection.register(SessionPickCell.self, forCellWithReuseIdentifier: SessionPickCell.identifier)
        departureSessionsTimeCollection.setCollectionViewLayout(flowLayout, animated: true)
        departureSessionsTimeCollection.dataSource = self
        departureSessionsTimeCollection.delegate = self
        departureSessionsTimeCollection.isUserInteractionEnabled = true
        
        contentView.addSubview(departureSessionsTimeCollection)
        departureSessionsTimeCollection.snp.makeConstraints { make in
            make.top.greaterThanOrEqualTo(departureSessionsLabel.snp.bottom)
            make.left.equalToSuperview().offset(8)
            make.right.equalToSuperview()
            make.height.equalTo(66)
        }
        
        
        departureSessionsTimeCollection.collectionViewLayout.invalidateLayout()
        departureSessionsTimeCollection.reloadData()
    }
    
    private func putReturnView(departures : [SessionPickModel]) {
        contentView.addSubview(returnSessionsLabel)
        returnSessionsLabel.snp.makeConstraints { make in
            if !departures.isEmpty {
                make.top.greaterThanOrEqualTo(departureSessionsTimeCollection.snp.bottom).offset(12)
            } else {
                make.top.greaterThanOrEqualTo(line.snp.bottom).offset(12)
            }
            make.left.lessThanOrEqualToSuperview().offset(16)
            make.height.equalTo(24)
        }

        returnSessionsTimeCollection.register(SessionPickCell.self, forCellWithReuseIdentifier: SessionPickCell.identifier)
        returnSessionsTimeCollection.setCollectionViewLayout(flowLayout, animated: true)
        returnSessionsTimeCollection.dataSource = self
        returnSessionsTimeCollection.delegate = self
        returnSessionsTimeCollection.isUserInteractionEnabled = true
        
        contentView.addSubview(returnSessionsTimeCollection)

        returnSessionsTimeCollection.snp.makeConstraints { make in
            make.top.greaterThanOrEqualTo(returnSessionsLabel.snp.bottom)
            make.left.equalToSuperview().offset(8)
            make.right.equalToSuperview()
            make.height.equalTo(66)
            returnSessionsTimeCollection.reloadData()
        }
        
        returnSessionsTimeCollection.collectionViewLayout.invalidateLayout()
        returnSessionsTimeCollection.reloadData()
    }
    
    static func height() -> CGFloat {
        return  cellSpacingHeight() + dayAndLineHeight() + labelWithCollectionHeight() + labelWithCollectionHeight()
    }
    
    static func singleListHeight() -> CGFloat {
        return cellSpacingHeight() + dayAndLineHeight() + labelWithCollectionHeight()
    }
    
    private static func labelWithCollectionHeight() -> CGFloat {
        return (itemSize.height) + 12 + 24
    }
    
    
    private static func dayAndLineHeight() -> CGFloat {
        return 24 + 8 + 1 + 16
    }
    
    private static func cellSpacingHeight() ->  CGFloat {
        return 36
    }
    
    func setDelegate(
        _ delegate: SessionListCellDelegate,
        at position: Int
    ) {
        self.delegate = delegate
        self.position = position
    }
}

extension SessionListCell: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == departureSessionsTimeCollection {
            return departureSessions().count
        } else  {
            return returnSessions().count
        }
    }
    
    private func departureSessions() -> [SessionPickModel] {
        let models = sessionPickList.filter { $0.isDeparture }
        return models
    }

    
    private func returnSessions()-> [SessionPickModel] {
        let models = sessionPickList.filter { !$0.isDeparture }
        return models
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SessionPickCell.identifier, for: indexPath) as? SessionPickCell
        
        guard let cell = cell else {
            return UICollectionViewCell()
        }

        let sessionPickList = getSessionsByView(collectionView)

        cell.configure(
            with: sessionPickList[indexPath.row],
            self
        )

        return cell
    }
    
    private func getSessionsByView(_ collectionView: UICollectionView) -> [SessionPickModel] {
        if collectionView == departureSessionsTimeCollection {
            return departureSessions()
        } else  {
            return returnSessions()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return SessionListCell.itemSize
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didSelectSession(
            sessionId: getSessionsByView(collectionView)[indexPath.row].sessionId,
            atTablePosition: position ?? 0)
    }
}


protocol SessionListCellDelegate: AnyObject {
    func didSelectSession(sessionId: Int, atTablePosition: Int)
}
