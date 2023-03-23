//
//  SessionListCell.swift
//  Shuttleasy
//
//  Created by OguzhanMac on 22.03.2023.
//

import Foundation
import UIKit

class SessionListCell : BaseTableViewCell {
    
    public static let identifier = "SessionListCell"
    
    let dateLabel = TitleMedium(text: "Monday")
    
    private let flowLayout = UICollectionViewFlowLayout()
    let sessionTimeCollectionView : BaseUICollectionView = BaseUICollectionView(frame: .zero, collectionViewLayout: .init())
    
    
    private var itemSize : CGSize = .init(width: 0, height: 0)
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .red
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 2
        contentView.addSubview(dateLabel)
        dateLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.left.equalToSuperview().offset(16)
            make.height.greaterThanOrEqualTo(24)
        }
        
        
        sessionTimeCollectionView.register(SessionPickCell.self, forCellWithReuseIdentifier: SessionPickCell.identifier)
        
        flowLayout.scrollDirection = .horizontal
        sessionTimeCollectionView.setCollectionViewLayout(flowLayout, animated: true)
        contentView.addSubview(sessionTimeCollectionView)


        sessionTimeCollectionView.snp.makeConstraints { make in
            make.top.greaterThanOrEqualTo(dateLabel.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(66)
        }
    }
    
    func configure(
        _ itemSize : CGSize = .init(width: 0, height: 0)
    ) {
        self.itemSize = itemSize
        flowLayout.itemSize = itemSize
        sessionTimeCollectionView.reloadData()
    }
    
}

extension SessionListCell: UICollectionViewDelegate {
    
}


extension SessionListCell: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SessionPickCell.identifier, for: indexPath) as? SessionPickCell
        
        if cell == nil {
            return UICollectionViewCell()
        }
        
        return cell!
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return itemSize
    }
    
}


extension SessionListCell: UICollectionViewDelegateFlowLayout {
    
}
