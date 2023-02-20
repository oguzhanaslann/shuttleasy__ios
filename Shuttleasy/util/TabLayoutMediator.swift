//
//  TabLayoutMediator.swift
//  pagerPrototype
//
//  Created by OguzhanMac on 18.02.2023.
//

import Foundation
import MaterialComponents.MaterialTabs_TabBarView
import SnapKit

class TabLayoutMediator: NSObject, MDCTabBarViewDelegate, UIScrollViewDelegate {
    
    private let tabBarView: MDCTabBarView
    private let scrollView : UIScrollView
    
    init(
        tabBarView : MDCTabBarView,
        scrollView : UIScrollView,
        configure: (Int) -> UITabBarItem
    ) {
        self.tabBarView = tabBarView
        self.scrollView = scrollView

        
        var tabs : [UITabBarItem] = []
        for tabIndex in 0..<scrollView.subviews.count {
            let tabBarItem  = configure(tabIndex)
            tabs.append(tabBarItem)
        }
        
        tabBarView.items = tabs
        tabBarView.selectedItem = tabBarView.items[0]
    }
    
    func attach() {
        self.tabBarView.tabBarDelegate = self
        self.scrollView.delegate = self
    }
    
    
    func tabBarView(_ tabBarView: MDCTabBarView, shouldSelect item: UITabBarItem) -> Bool {
        print("shouldSelect " + (item.title ?? "" ))
        let position =  tabBarView.items.firstIndex(of: item) ?? 0
        scrollView.scrollTo(horizontalPage: position)
        return false
    }
    
    func tabBarView(_ tabBarView: MDCTabBarView, didSelect item: UITabBarItem) {
        print("Selected " + (item.title ?? "" ))
        let position =  tabBarView.items.firstIndex(of: item) ?? 0
        scrollView.scrollTo(horizontalPage: position)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = scrollView.currentHorizontalPosition
        print("scrolled to : index = \(pageIndex)")
        tabBarView.selectedItem = tabBarView.items[Int(pageIndex)]
    }
}

extension UIScrollView {
    var currentHorizontalPosition: Int {
        get {
            let pageIndex = round(self.contentOffset.x / self.frame.width)
            return Int(pageIndex)
        }
    }
    
}
