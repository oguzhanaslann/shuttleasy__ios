//
//  BaseUICollectionView.swift
//  Shuttleasy
//
//  Created by OguzhanMac on 23.03.2023.
//

import UIKit

class BaseUICollectionView: UICollectionView {

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureView()
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        configureView()
    }
    
    private func configureView() {
        defaultSetup()
    }
}
