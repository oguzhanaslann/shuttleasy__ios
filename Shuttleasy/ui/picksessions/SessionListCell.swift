//
//  SessionListCell.swift
//  Shuttleasy
//
//  Created by OguzhanMac on 22.03.2023.
//

import Foundation
import UIKit

class SessionListCell : BaseTableViewCell, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    public static let identifier = "SessionListCell"
    
    private static let itemSize = CGSize(width: 96, height: 42)
    public static let height = itemSize.height + ( 12 * 2 ) + 24 + 12
    
    private let dateLabel = TitleMedium()
    
    private let flowLayout = UICollectionViewFlowLayout()
    let sessionTimeCollectionView : BaseUICollectionView = BaseUICollectionView(
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
            make.height.greaterThanOrEqualTo(24)
        }
        
        sessionTimeCollectionView.register(SessionPickCell.self, forCellWithReuseIdentifier: SessionPickCell.identifier)
        
        flowLayout.scrollDirection = .horizontal
        flowLayout.itemSize = SessionListCell.itemSize
        sessionTimeCollectionView.setCollectionViewLayout(flowLayout, animated: true)
        sessionTimeCollectionView.dataSource = self
        sessionTimeCollectionView.delegate = self
        sessionTimeCollectionView.isUserInteractionEnabled = true
        contentView.addSubview(sessionTimeCollectionView)


        sessionTimeCollectionView.snp.makeConstraints { make in
            make.top.greaterThanOrEqualTo(dateLabel.snp.bottom)
            make.left.equalToSuperview().offset(8)
            make.right.equalToSuperview()
            make.height.equalTo(66)
            sessionTimeCollectionView.reloadData()
        }
    }


    func configure(
        with model: SessionPickListModel
    ) {
        dateLabel.text = model.dayName
        self.sessionPickList = model.sessionPickList
        
        sessionTimeCollectionView.reloadData()
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
        return sessionPickList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SessionPickCell.identifier, for: indexPath) as? SessionPickCell
        
        guard let cell = cell else {
            return UICollectionViewCell()
        }

        cell.configure(
            with: sessionPickList[indexPath.row],
            self
        )

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return SessionListCell.itemSize
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didSelectSession(atRow: indexPath.row, atTablePosition: position ?? 0)
    }
}


protocol SessionListCellDelegate: AnyObject {
    func didSelectSession(atRow: Int, atTablePosition: Int)
}
