//
//  CompanyDetailViewController.swift
//  Shuttleasy
//
//  Created by OguzhanMac on 19.02.2023.
//

import UIKit
import MaterialComponents.MaterialTabs_TabBarView
import SnapKit

class CompanyDetailViewController: BaseViewController {
    
    private static let ABOUT_PAGE_INDEX = 0
    private static let SHUTTLES_PAGE_INDEX = 1

    lazy var imageContainer = {
        let imageContainer = UIView()
        
        let image = UIImageView(image : UIImage(named: "shuttle_placeholder"))
        imageContainer.addSubview(image)
       
        image.layer.backgroundColor = UIColor.gray.cgColor
        
        image.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
        }
            
        image.addoverlay(alpha: 0.33)
        
        return imageContainer
    }()
    
    lazy var companyHeader = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        
        let companyNameTitle = HeadlineSmall(text: "Header", color: .white)
        
        companyNameTitle.breakLineFromEndIfNeeded()
        
        
        let companyShortSlogan = LabelMedium(text: "slogan", color: .white)
        companyShortSlogan.breakLineFromEndIfNeeded()
        
        stackView.addArrangedSubview(companyNameTitle)
        stackView.addArrangedSubview(companyShortSlogan)

        return stackView
    }()
    
    lazy var tabBarView =  {
        let tabBarView = MDCTabBarView()
        tabBarView.preferredLayoutStyle = .fixed
        tabBarView.sizeToFit()
        tabBarView.tintColor = primaryContainer
        tabBarView.barTintColor = primaryContainer
        tabBarView.indicatorStyle = .white
        tabBarView.bottomDividerColor = onPrimaryContainer.withAlphaComponent(0.5)
        tabBarView.tintColorDidChange()
        tabBarView.setContentPadding(.zero, for: .scrollable)
        return tabBarView
    }()
    
    lazy var pointBadgeView = {
        let badge = UIView()
        badge.backgroundColor = secondaryColor
        badge.clipsToBounds = true
        badge.layer.cornerRadius = 12
        badge.layer.maskedCorners = [.layerMinXMinYCorner]
        
        
        let starIcon = UIImage(systemName: "star.fill")?.withRenderingMode(.alwaysTemplate)
        let starImageView = UIImageView(image: starIcon)
        starImageView.tintColor = UIColor.white
        badge.addSubview(starImageView)
        starImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(8)
            make.size.equalTo(14)
            make.centerY.equalToSuperview()
        }
        
        let ratings = LabelMedium(text: "8.8(500)", color: onSecondaryColor)
        badge.addSubview(ratings)
        ratings.snp.makeConstraints { make in
            make.left.equalTo(starImageView.snp.right).offset(8)
            make.centerY.equalToSuperview()
        }
        
        return badge
    }()
    
    
    private var pages : [UIView] = [
        CompanyAboutView(),
        CompanyShuttlesView()
    ]

    lazy var scrollView : UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = true
        let guide = self.view.safeAreaLayoutGuide
        
        scrollView.contentSize = CGSize(
            width: view.frame.width * CGFloat(pages.count),
            height: (guide.layoutFrame.size.height - 256)
        )
        
        for index in 0..<pages.count {
            let pageView = pages[index]
            pageView.backgroundColor = backgroundColor
            scrollView.addSubview(pageView)
            pageView.frame = CGRect(
                x: view.frame.width * CGFloat(index),
                y: 0,
                width: view.frame.width,
                height: (guide.layoutFrame.size.height - 256)
            )
        }
        
        return scrollView
    }()
    
    private var mediator : TabLayoutMediator? = nil
    
    let imageHeight = 200
    let tabsHeight = 56
    var scrollViewHeight: CGFloat {
        get {
            return safeAreaHeight() - CGFloat(imageHeight) - CGFloat(tabsHeight)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(imageContainer)
        view.addSubview(companyHeader)
        view.addSubview(tabBarView)
        view.addSubview(scrollView)
        view.addSubview(pointBadgeView)

        imageContainer.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(imageHeight)
        }
        
        pointBadgeView.snp.makeConstraints { make in
            view.bringSubviewToFront(pointBadgeView)
            make.bottom.equalTo(imageContainer.snp.bottom)
            make.width.equalTo(105)
            make.height.equalTo(28)
            make.right.lessThanOrEqualToSuperview()
        }
        
        companyHeader.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(24)
            make.bottom.equalTo(imageContainer.snp.bottom).inset(16)
            make.right.lessThanOrEqualTo(pointBadgeView.snp.left).inset(8)
        }
        
      
        tabBarView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.top.greaterThanOrEqualTo(imageContainer.snp.bottom)
            make.height.greaterThanOrEqualTo(tabsHeight)
        }
        
        scrollView.snp.makeConstraints { make in
            view.bringSubviewToFront(scrollView)
            make.top.equalTo(tabBarView.snp.bottom)
            make.width.equalTo(view.snp.width)
            make.height.equalTo((scrollViewHeight))
        }
        
        
        attachThePagerComponents()
    }
    
    private func safeAreaHeight() -> CGFloat {
        let guide = self.view.safeAreaLayoutGuide
        return guide.layoutFrame.size.height
    }
    
    private func attachThePagerComponents() {
        mediator =  TabLayoutMediator(
            tabBarView: tabBarView,
            scrollView: scrollView
        ) { pageIndex in
            if ( pageIndex == CompanyDetailViewController.ABOUT_PAGE_INDEX) {
               return UITabBarItem(title: "About", image: UIImage(named: "phone"), tag: pageIndex)
            } else if pageIndex == CompanyDetailViewController.SHUTTLES_PAGE_INDEX {
               return UITabBarItem(title: "Shuttles", image: UIImage(named: "phone"), tag: pageIndex)
            } else {
                return UITabBarItem(title: "", image: UIImage(named: "phone"), tag: pageIndex)
            }
        }
        
        mediator?.attach()
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
          return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavBackButton(navigationItem: navigationItem, target: self, action: #selector(dismissView))
    }
    
    @objc func dismissView() {
        dismiss(animated: true, completion: nil)
    }

    override func viewDidLayoutSubviews() {
        print(imageContainer.frame.width)
    }
    
    override func shouldSetStatusBarColor() -> Bool {
        return false
    }
    
    
    override func getNavigationBarBackgroundColor() -> UIColor {
        return .clear
    }
    
    override func getNavigationBarTintColor() -> UIColor {
        return .white
    }
    
    override func getNavigationBarTitleStyle(titleColor: UIColor = onPrimaryContainer, font: UIFont = LabelLargeFont(16)) -> [NSAttributedString.Key : NSObject] {
        var attrs = super.getNavigationBarTitleStyle(titleColor: titleColor, font: font)
        attrs[NSAttributedString.Key.foregroundColor]  = getNavigationBarTintColor()
        return attrs
    }
}
