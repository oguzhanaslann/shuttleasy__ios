//
//  CompanyAboutView.swift
//  Shuttleasy
//
//  Created by OguzhanMac on 23.02.2023.
//

import Foundation
import UIKit


class CompanyAboutView: UIView {
    
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
        self.addSubview(tableView)
        tableView.backgroundColor = backgroundColor
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.register(CommentCell.self, forCellReuseIdentifier: CommentCell.identifier)
        tableView.register(CompanyStatusCell.self, forCellReuseIdentifier: CompanyStatusCell.identifier)
        tableView.register(CompanyHeaderCell.self, forCellReuseIdentifier: CompanyHeaderCell.identifier)
        tableView.register(CompanyContentCell.self, forCellReuseIdentifier: CompanyContentCell.identifier)
        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalToSuperview()
        }
    }
    
    override func layoutSubviews() {
        tableView.reloadData()
    }
     
}


extension CompanyAboutView : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : UITableViewCell?
            
        switch indexPath.row {
        case 0:
            cell = tableView.dequeueReusableCell(
                withIdentifier: CompanyStatusCell.identifier,
                for: indexPath
            ) as? CompanyStatusCell

        case 1:
            cell = tableView.dequeueReusableCell(
                withIdentifier: CompanyHeaderCell.identifier,
                for: indexPath
            ) as? CompanyHeaderCell
        case 2:
            cell = tableView.dequeueReusableCell(
                withIdentifier: CompanyContentCell.identifier,
                for: indexPath
            ) as? CompanyContentCell
        case 3:
            cell = tableView.dequeueReusableCell(
                withIdentifier: CompanyHeaderCell.identifier,
                for: indexPath
            ) as? CompanyHeaderCell
        default:
            cell = tableView.dequeueReusableCell(
                withIdentifier: CommentCell.identifier,
                for: indexPath
            ) as? CommentCell
        }

        
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
//        let personId = personList[indexPath.row].id
//        navigationController?.pushViewController(PersonDetailViewController(personId: personId), animated: true)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


extension CompanyAboutView : UITableViewDelegate {
    
}

