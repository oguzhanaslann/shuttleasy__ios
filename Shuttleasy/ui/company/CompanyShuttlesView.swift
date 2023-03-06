//
//  CompanyShuttlesView.swift
//  Shuttleasy
//
//  Created by OguzhanMac on 1.03.2023.
//

import Foundation
import UIKit

class CompanyShuttlesView: UIView {
    
    let tableView: UITableView = UITableView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initView()
    }
    
    private func initView() {
        tableView.backgroundColor = backgroundColor
        tableView.delegate = self
        tableView.dataSource = self
        tableView.defaultSetup()
        tableView.separatorStyle = .singleLine
        tableView.register(CompanyShuttleCell.self, forCellReuseIdentifier: CompanyShuttleCell.identifier)
        addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalToSuperview()
        }
    }
}

extension CompanyShuttlesView : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(
            withIdentifier: CompanyShuttleCell.identifier,
            for: indexPath
        ) as? CompanyShuttleCell
        
        
        
        if cell == nil {
            return UITableViewCell()
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NSLog("clicked %d", indexPath.row)        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension CompanyShuttlesView : UITableViewDelegate {
}
