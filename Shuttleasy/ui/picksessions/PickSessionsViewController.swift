//
//  PickSessionsViewController.swift
//  Shuttleasy
//
//  Created by OguzhanMac on 21.03.2023.
//

import UIKit
import SnapKit
import Combine

struct PickSessionsArgs {
    let companyId : Int
    let destinationPoint: CGPoint
    let sessionPickModel : [SessionPickListModel]
}

class PickSessionsViewController: BaseViewController, UITableViewDelegate {
    
    private let viewModel = Injector.shared.injectPickSessionsViewModel()
    private var sessionPickListObserver : AnyCancellable? = nil
    
    private let args : PickSessionsArgs
    private var sessionPickModelList :  [SessionPickListModel] = []

    private let tableView: UITableView = BaseUITableView()
    
    init(args : PickSessionsArgs){
        self.args = args
        viewModel.setSessionModels(args.sessionPickModel)
        super.init(nibName: nil, bundle: nil)
    }
       
    required init(coder : NSCoder){
        fatalError()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Pick your sessions"
        initViews()
        subscribeObervers()
    }

    private func initViews() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SessionListCell.self, forCellReuseIdentifier: SessionListCell.identifier)
        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalToSuperview()
        }
    }
    
    private func subscribeObervers() {
        sessionPickListObserver = viewModel.sessionModelListPublisher
            .receive(on: DispatchQueue.main)
            .sink(
                receiveValue: { [weak self] pickModelList in
                    self?.sessionPickModelList = pickModelList.first
                    self?.reloadDataOfSessions(pickModelList)
                    self?.tableView.layoutIfNeeded()
                }
            )
    }
    
    private func reloadDataOfSessions(_ pickModelList: Pair<[SessionPickListModel], Int?>) {
        if let updateIndex =  pickModelList.second {
            self.reloadDataAndKeepScrollState(updateIndex)
        } else {
            self.tableView.reloadData()
        }
    }
    
    private func reloadDataAndKeepScrollState(_ updateIndex: Int) {
        let cell = self.tableView.cellForRow(
            at: IndexPath(row: updateIndex, section: 0)
        ) as? SessionListCell
        
        let collectionView = cell?.sessionTimeCollectionView
        let scrollState = collectionView?.contentOffset
        
        tableView.reloadRows(at: [IndexPath(row: updateIndex, section: 0)], with: .none)
        
        if let scrollState = scrollState {
            collectionView?.layoutIfNeeded()
            collectionView?.setContentOffset(scrollState, animated: false)
        }
    }
    
    override func getNavigationBarBackgroundColor() -> UIColor {
        return .clear
    }
    
    override func getNavigationBarTintColor() -> UIColor {
        return .black
    }
    
    override func shouldSetStatusBarColor() -> Bool {
        return false
    }
    
    override func getStatusBarColor() -> UIColor {
        .clear
    }
}

extension PickSessionsViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SessionListCell.height
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sessionPickModelList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let statusCell =  tableView.dequeueReusableCell(
            withIdentifier: SessionListCell.identifier,
            for: indexPath
        ) as? SessionListCell
        
        guard let statusCell = statusCell else {
            return UITableViewCell()
        }
        
        statusCell.setDelegate(self, at: indexPath.row)
        statusCell.configure(
            with: sessionPickModelList[indexPath.row]
        )

        return statusCell
    }
}

extension PickSessionsViewController: SessionListCellDelegate {
    func didSelectSession(atRow: Int, atTablePosition: Int) {
        viewModel.onSessionToggleReceive(pickModelIndex: atTablePosition, sessionIndex: atRow)
    }
}
