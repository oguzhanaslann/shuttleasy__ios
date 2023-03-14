//
//  CompanyShuttlesView.swift
//  Shuttleasy
//
//  Created by OguzhanMac on 1.03.2023.
//

import Foundation
import UIKit
import Combine

class CompanyShuttlesView: UIView {
    
    private let tableView: UITableView = UITableView()
    private var viewModel: CompanyDetailViewModel? = nil
    
    private var companyDetailObserver: AnyCancellable? = nil
    private var companyDetail : CompanyDetail? = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initView()
    }
    
    convenience init(viewModel : CompanyDetailViewModel) {
        self.init(frame: CGRect.zero)
        print("view model creation")
        self.viewModel = viewModel
        subscribeObservers()
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
    
}

extension CompanyShuttlesView : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return companyDetail?.shuttles.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(
            withIdentifier: CompanyShuttleCell.identifier,
            for: indexPath
        ) as? CompanyShuttleCell
        
        
        cell?.initialize(with : companyDetail?.shuttles[indexPath.row])
        
        
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
