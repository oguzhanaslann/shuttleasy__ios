//
//  MainViewController.swift
//  Shuttleasy
//
//  Created by Oğuzhan Aslan on 20.11.2022.
//

import UIKit

class MainViewController: BaseTabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        initTabBar()
    }

    func initTabBar() {
        let homepageVC = UINavigationController(rootViewController:  HomepageViewContoller())
        let searchVC = UINavigationController(rootViewController:  SearchShuttleViewContoller())
        let profileVC = UINavigationController(rootViewController: ProfileViewController())
        
        profileVC.navigationBar.barTintColor = primaryColor

        viewControllers = [homepageVC, searchVC, profileVC]
    
        tabBar.items?[0].title = "Home"
        tabBar.items?[0].image = UIImage(systemName: "house")
      
        tabBar.items?[1].title = "Search"
        tabBar.items?[1].image = UIImage(systemName: "magnifyingglass")
    
        tabBar.items?[2].title = "Profile"
        tabBar.items?[2].image = UIImage(systemName: "person.fill")
    }
}
