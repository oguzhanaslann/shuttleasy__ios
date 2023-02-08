//
//  MainViewController.swift
//  Shuttleasy
//
//  Created by Oğuzhan Aslan on 20.11.2022.
//

import UIKit
import Combine

class MainViewController: BaseTabBarController {
    
    private let mainViewModel : MainViewModel = Injector.shared.injectMainViewModel()
    private var profileTypeObserver : AnyCancellable? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        let profileType = mainViewModel.currentProfileType()
        initTabBar(profileType: profileType)
        subscribeObservers()
        mainViewModel.getProfileType()
    }

    private func initTabBar(profileType : ProfileType) {
        let homepageVC = UINavigationController(rootViewController:  HomepageViewContoller())
        let profileVC = UINavigationController(rootViewController: ProfileViewController())
        
        switch (profileType) {   
            case .passenger:
                let searchVC = UINavigationController(rootViewController:  SearchShuttleViewContoller())
                viewControllers = [homepageVC, searchVC, profileVC]            
                setTabbarIndexAsHome(0)
                setTabbarIndexAsSearch(1)
                setTabbarIndexAsProfile(2)
            case .driver:
                print("here")
                viewControllers = [homepageVC, profileVC]
                setTabbarIndexAsHome(0)
                setTabbarIndexAsProfile(1)
        }
        
        selectedViewController = viewControllers![0]
    }
    
    private func setTabbarIndexAsHome(_ index : Int) {
        tabBar.items?[index].title = Localization.home.localized
        tabBar.items?[index].image = UIImage(systemName: "house")
    }

    private func setTabbarIndexAsSearch( _ index : Int) {
        tabBar.items?[index].title = Localization.search.localized
        tabBar.items?[index].image = UIImage(systemName: "magnifyingglass")
    }

    private func setTabbarIndexAsProfile( _ index : Int) {
        tabBar.items?[index].title = Localization.profile.localized
        tabBar.items?[index].image = UIImage(systemName: "person.fill")
    }

    private func subscribeObservers() {
        profileTypeObserver = mainViewModel.profileType
            .receive(on: DispatchQueue.main)
            .sink { profileType in
            self.initTabBar(profileType: profileType)
        }
    }


}
