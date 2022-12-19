//
//  SearchResultViewController.swift
//  Shuttleasy
//
//  Created by Oğuzhan Aslan on 19.12.2022.
//

import Foundation
import UIKit

protocol SearchUpdateListener {
    func onSearchResultUpdated(results : [SearchResult])
}

class SearchResultViewController : UIViewController, SearchUpdateListener {
    let tableView = UITableView()
    
    var results: [SearchResult] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = backgroundColor
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalToSuperview().offset(16)
        }
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.register(SearchResultCell.self, forCellReuseIdentifier: SearchResultCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func onSearchResultUpdated(results: [SearchResult]) {
        print("Updated")
        // clear results and add new results
        self.results.removeAll()
        self.results.append(contentsOf: results)
        // reload the table view
        tableView.reloadData()
    }
}

extension SearchResultViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // dequeue the cell
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultCell.identifier, for: indexPath) as! SearchResultCell
        // configure the cell
        cell.configure(with: results[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected")
        // deselect the row
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
