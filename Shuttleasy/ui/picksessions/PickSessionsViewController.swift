//
//  PickSessionsViewController.swift
//  Shuttleasy
//
//  Created by OguzhanMac on 21.03.2023.
//

import UIKit

struct PickSessionsArgs {
    let companyId : Int
    let destinationPoint: CGPoint
    let sessionPickModel : [SessionPickListModel]
}

class PickSessionsViewController: BaseViewController, UITableViewDelegate {
    
    private let args : PickSessionsArgs

    private let tableView: UITableView = BaseUITableView()
    
    init(args : PickSessionsArgs){
        self.args = args
        super.init(nibName: nil, bundle: nil)
    }
       
    required init(coder : NSCoder){
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Pick your sessions"
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
        return args.sessionPickModel.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let statusCell =  tableView.dequeueReusableCell(
            withIdentifier: SessionListCell.identifier,
            for: indexPath
        ) as? SessionListCell
        
        guard let statusCell = statusCell else {
            return UITableViewCell()
        }
        
        statusCell.delegate = self
        statusCell.configure(
            with: args.sessionPickModel[indexPath.row]
        )

        return statusCell
    }
}

extension PickSessionsViewController: SessionListCellDelegate {
    func didSelectSession(atRow: Int) {
        print("didSelectSession atRow: \(atRow)")
    }
}
