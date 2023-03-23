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
    let pickupPoint: CGPoint
}

class PickSessionsViewController: BaseViewController {
    
    private let args : PickSessionsArgs

    private let tableView: UITableView = UITableView()
    
    private let itemSize = CGSize(width: 96, height: 42)
    
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
        tableView.defaultSetup()
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
        return itemSize.height + ( 12 * 2) + 24 
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let statusCell =  tableView.dequeueReusableCell(
            withIdentifier: SessionListCell.identifier,
            for: indexPath
        ) as? SessionListCell
        
        statusCell?.sessionTimeCollectionView.delegate = self
        statusCell?.sessionTimeCollectionView.dataSource = self
        statusCell?.configure(itemSize)

        
        return statusCell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NSLog("clicked %d", indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension PickSessionsViewController : UITableViewDelegate {
    
}

extension PickSessionsViewController: UICollectionViewDelegate {
    
}

extension PickSessionsViewController: UICollectionViewDataSource {
    
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
