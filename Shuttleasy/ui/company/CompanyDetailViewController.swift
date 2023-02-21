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
    
    lazy var imageContainer = {
        let imageContainer = UIView()
        
        let image = UIImageView()
        imageContainer.addSubview(image)
       
        image.layer.backgroundColor = UIColor.gray.cgColor
        image.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
        }
        
        return imageContainer
    }()
    
    lazy var companyNameTitle = {
        return HeadlineSmall(text: "Header", color: .white)
    }()
    
    lazy var companyShortSlogan = {
        return LabelMedium(text: "slogan", color: .white)
    }()
    
    lazy var companyHeader = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        
        let companyNameTitle = HeadlineSmall(text: "Header", color: .white)
        
        let companyShortSlogan = LabelMedium(text: "slogan", color: .white)
        
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
    
    
    private var pages : [UIView] = [
        UIView(),
        UIView()
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

        imageContainer.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(imageHeight)
        }
        
        companyHeader.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(24)
            make.bottom.equalTo(imageContainer.snp.bottom).inset(16)
        }
        
        tabBarView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.top.greaterThanOrEqualTo(imageContainer.snp.bottom)
            make.height.greaterThanOrEqualTo(tabsHeight)
        }
        
        let height = safeAreaHeight()
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
             UITabBarItem(title: "Recents", image: UIImage(named: "phone"), tag: pageIndex)
        }
        
        mediator?.attach()
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
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
