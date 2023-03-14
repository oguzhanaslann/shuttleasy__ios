//
//  CompanyAboutView.swift
//  Shuttleasy
//
//  Created by OguzhanMac on 23.02.2023.
//

import Foundation
import UIKit
import Combine


class CompanyAboutView: UIView {
    
    private let tableView: UITableView = UITableView()
    private var viewModel: CompanyDetailViewModel? = nil
    private var companyDetailObserver: AnyCancellable? = nil
    
    
    private var companyDetail: CompanyDetail? = nil
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    private func initView() {
        self.addSubview(tableView)
        tableView.backgroundColor = backgroundColor
        tableView.delegate = self
        tableView.dataSource = self
        tableView.defaultSetup()
        tableView.register(CommentCell.self, forCellReuseIdentifier: CommentCell.identifier)
        tableView.register(CompanyStatusCell.self, forCellReuseIdentifier: CompanyStatusCell.identifier)
        tableView.register(CompanyHeaderCell.self, forCellReuseIdentifier: CompanyHeaderCell.identifier)
        tableView.register(CompanyContentCell.self, forCellReuseIdentifier: CompanyContentCell.identifier)
        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalToSuperview()
        }
        
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: 56, right: 0)
        tableView.contentInset = insets
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError()
    }
    
    convenience init(viewModel : CompanyDetailViewModel) {
        self.init(frame: CGRect.zero)
        self.viewModel = viewModel
        subscribeObservers()
    }
    
    private func subscribeObservers() {
        companyDetailObserver = viewModel?.companyDetailPublisher
                .receive(on: DispatchQueue.main)
                .sink(
                    receiveCompletion: { _ in },
                    receiveValue: { [weak self] result in
                        result.onSuccess { data in
                            self?.onCompanyDetailResult(data.data)
                        }
                    }
                )
    }
    
    private func onCompanyDetailResult(_ companyDetail: CompanyDetail) {
        self.companyDetail = companyDetail
        tableView.reloadData()
    }
    
    
    override func layoutSubviews() {
        tableView.reloadData()
    }
     
}


extension CompanyAboutView : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let commentCount = self.companyDetail?.comments.count ?? 0
        return 4 + commentCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : UITableViewCell?
            
        switch indexPath.row {
        case 0:
            
            let statusCell =  tableView.dequeueReusableCell(
                withIdentifier: CompanyStatusCell.identifier,
                for: indexPath
            ) as? CompanyStatusCell
            
            statusCell?.initialize(with: companyDetail)
            
            cell = statusCell

        case 1:
            cell = tableView.dequeueReusableCell(
                withIdentifier: CompanyHeaderCell.identifier,
                for: indexPath
            ) as? CompanyHeaderCell
            
            if let header = (cell as? CompanyHeaderCell) {
                header.setTitle(Localization.contact.localized)
            }
            
        case 2:
            let contentCell = tableView.dequeueReusableCell(
                withIdentifier: CompanyContentCell.identifier,
                for: indexPath
            ) as? CompanyContentCell

            contentCell?.initialize(with: companyDetail)

            cell = contentCell

        case 3:
            cell = tableView.dequeueReusableCell(
                withIdentifier: CompanyHeaderCell.identifier,
                for: indexPath
            ) as? CompanyHeaderCell
            
            if let header = (cell as? CompanyHeaderCell) {
                header.setTitle(Localization.comments.localized)
            }
            
        default:
            let commentCell = tableView.dequeueReusableCell(
                withIdentifier: CommentCell.identifier,
                for: indexPath
            ) as? CommentCell

            commentCell?.initialize(with: companyDetail?.comments[indexPath.row - 4])

            cell = commentCell
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
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


extension CompanyAboutView : UITableViewDelegate {
    
}

