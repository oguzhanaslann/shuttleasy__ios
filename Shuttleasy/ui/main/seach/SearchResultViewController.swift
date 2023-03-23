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

protocol SearchResultClickedListener {
    func onSearchResultClicked(result: SearchResult)
}

class SearchResultViewController : UIViewController, SearchUpdateListener {
    let tableView = BaseUITableView()
    
    var results: [SearchResult] = []
    
    private var searchResultClickedListener : SearchResultClickedListener? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = backgroundColor
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalToSuperview().offset(16)
        }
        
        tableView.register(SearchResultCell.self, forCellReuseIdentifier: SearchResultCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func onSearchResultUpdated(results: [SearchResult]) {
        self.results.removeAll()
        self.results.append(contentsOf: results)
        tableView.reloadData()
    }

    func setOnSearchResultClickedListener(listener : SearchResultClickedListener) {
        self.searchResultClickedListener = listener
    }
}

extension SearchResultViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultCell.identifier, for: indexPath) as! SearchResultCell
        cell.configure(with: results[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        searchResultClickedListener?.onSearchResultClicked(result: results[indexPath.row])
    }
}
