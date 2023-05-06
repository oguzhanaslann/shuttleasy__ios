//
//  SearchResultViewController.swift
//  Shuttleasy
//
//  Created by Oğuzhan Aslan on 19.12.2022.
//

import Foundation
import UIKit
import Lottie

protocol SearchUpdateListener {
    func onSearchResultUpdated(results : [SearchResult])
}

protocol SearchResultClickedListener {
    func onSearchResultClicked(result: SearchResult)
}

class SearchResultViewController : UIViewController, SearchUpdateListener {
    let tableView = BaseUITableView()
    
    var results: [SearchResult] = []
    
    private var lottieAnimView : UIView? = nil
    
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
        addOrRemoveNoResultViewBy(results: results)
        self.results.removeAll()
        self.results.append(contentsOf: results)
        tableView.reloadData()
    }
    
    private func addOrRemoveNoResultViewBy(results: [SearchResult]) {
        if(results.isEmpty) {
            if let file = getLottieFile() {
                lottieAnimView = emptyResultView(file : file)
                view.addSubview(lottieAnimView!)
                lottieAnimView?.snp.makeConstraints({ make in
                    make.top.equalToSuperview().offset(16)
                    make.centerX.equalToSuperview()
                })
            }
        } else {
            lottieAnimView?.removeFromSuperview()
            lottieAnimView = nil
        }
    }
    
    private func emptyResultView(file :String) -> UIView {
        let container = UIView()
        
        let noResultLabel = LabelMedium(text: Localization.noResultFound.localized)
        container.addSubview(noResultLabel)
        noResultLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(SpacingLarge)
            make.centerX.equalToSuperview()
            make.left.lessThanOrEqualToSuperview()
            make.right.lessThanOrEqualToSuperview()
        }
        
        noResultLabel.breakLineFromEndIfNeeded()
        
        let lottieAnimView = LottieAnimationView(filePath: file)
        lottieAnimView.loopMode = .loop
        lottieAnimView.play()
        container.addSubview(lottieAnimView)
        lottieAnimView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(noResultLabel.snp.bottom).offset(SpacingXSmall)
            make.size.lessThanOrEqualTo(180)
        }
        
        
        
        return container
    }
    
    func getLottieFile() -> String? {
        guard let file = Bundle.main.path(forResource: emptySearchLottie, ofType: "json") else { return nil }
        return file
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
