//
//  BaseUITableView.swift
//  Shuttleasy
//
//  Created by OguzhanMac on 23.03.2023.
//

import UIKit

class BaseUITableView: UITableView {
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureView()
    }
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        configureView()
    }
    
    private func configureView() {
        defaultSetup()
    }

}
