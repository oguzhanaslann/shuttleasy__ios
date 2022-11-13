//
//  ViewController.swift
//  Shuttleasy
//
//  Created by Oğuzhan Aslan on 14.10.2022.
//

import UIKit
import SnapKit

class ViewController: BaseViewController, UIScrollViewDelegate {
    
    private let onboardViewModel = Injector.shared.injectOnboardViewModel()

    lazy var placeholderView : UIView = {
        let view = UIView()
        view.backgroundColor = primaryColor
        return view
    }()
    
    lazy var onboardingPage1 : UIView = {
        return onboardingView(
            image: resImage(name:"onboard1"),
            slogan: "Lorem ipsum dolor sit amet, consectetur adipiscing elit"
        )
    }()
    
    lazy var onboardingPage2 : UIView = {
        return onboardingView(
            image: resImage(name:"onboard2"),
            slogan: "Lorem ipsum dolor sit amet, consectetur adipiscing elit"
        )
    }()
    
    lazy var onboardingPage3 : UIView = {
        return onboardingView(
            image: resImage(name:"onboard3"),
            slogan: "Lorem ipsum dolor sit amet, consectetur adipiscing elit"
        )
    }()
    
    func onboardingView(
        image : UIImageView,
        slogan : String
    ) -> UIView {
        let view = UIView()
        view.backgroundColor = secondaryColor
        view.layer.cornerRadius = roundedMediumCornerRadius
        let iconImage : UIImageView = image
        view.addSubview(iconImage)
        iconImage.snp.makeConstraints { make in
            make.top.greaterThanOrEqualTo(view.snp.top).offset(16)
            make.centerX.equalTo(view.snp.centerX)
        }
        
        let label = TitleMedium(text: slogan,color: onSecondaryColor)
        label.breakLineFromEndIfNeeded()
        
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.bottom.lessThanOrEqualTo(view.snp.bottom).offset(-64)
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
        }
        label.textAlignment = .center
        
        return view
    }
    
    lazy var pages : [UIView] = [onboardingPage1,onboardingPage2,onboardingPage3]
    
    lazy var pageControll : UIPageControl = {
        let pageControll = UIPageControl()
        pageControll.numberOfPages = pages.count
        pageControll.currentPageIndicatorTintColor = tertiary
        pageControll.pageIndicatorTintColor = surfaceVariant
        pageControll.addTarget(self, action: #selector(pageControlTapHandler(sender:)), for: .touchUpInside)
        return pageControll
    }()
    
    @objc
    func pageControlTapHandler(sender : UIPageControl) {
        scrollView.scrollTo(horizontalPage: sender.currentPage)
    }
    
    lazy var scrollView : UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = true

        scrollView.contentSize = CGSize(
            width: view.frame.width * CGFloat(pages.count),
            height: view.frame.height * 0.50
        )
        
        for index in 0..<pages.count {
            let pageView = pages[index]
            scrollView.addSubview(pageView)
            pageView.frame = CGRect(
                x: view.frame.width * CGFloat(index) + 32 ,
                y: 0,
                width: view.frame.width - 64,
                height: view.frame.height * 0.50
            )
        }
       
        
        return scrollView
    }()
    
    
    lazy var nextPageButton : UIButton = {
        let button = LargeButton(titleOnNormalState: "Next", backgroundColor: primaryColor, titleColorOnNormalState: onPrimaryColor)
        button.setOnClickListener {
            self.buttonAction()
        }
        return button
    }()
    
    func buttonAction() {
        let currentPage = Int(round(scrollView.contentOffset.x / view.frame.width))
        let lastPageIndex = pageControll.numberOfPages - 1
        let isLastPage = currentPage ==  lastPageIndex
        if isLastPage   {
            onboardViewModel.markOnboardAsSeen()
            //WindowDelegate.shared.setRootViewController( rootViewController: AuthenticationViewController())
        } else {
            scrollView.scrollTo(horizontalPage: currentPage + 1)
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        view.addSubview(scrollView)
        scrollView.delegate = self

        view.addSubview(placeholderView)
        view.addSubview(pageControll)
        view.addSubview(nextPageButton)
        
        placeholderView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalTo(scrollView.snp.centerY)
            make.left.right.equalToSuperview()
        }
                
        scrollView.snp.makeConstraints { make in
            view.bringSubviewToFront(scrollView)
            make.top.equalToSuperview().offset(64)
            make.left.equalTo(view.snp.left)
            make.right.equalTo(view.snp.right)
            make.width.equalTo(view.snp.width)
            make.height.equalTo(view.frame.height * 0.5)
        }
        scrollView.delegate = self
        pageControll.snp.makeConstraints { make in
            make.top.greaterThanOrEqualTo(scrollView.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
        }
        
        nextPageButton.snp.makeConstraints { make in
            make.bottom.lessThanOrEqualToSuperview().offset(-48)
            make.left.greaterThanOrEqualToSuperview().offset(24)
            make.right.greaterThanOrEqualToSuperview().offset(-24)
            make.height.equalTo(largeButtonHeight)
            make.centerX.equalToSuperview()
        }
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x / view.frame.width)
        pageControll.currentPage = Int(pageIndex)
        
        let isLastPage = Int(pageIndex) == (pageControll.numberOfPages - 1 )
        if isLastPage {
            //nextPageButton.setTitle(Localization.localized(.start), for: .normal)
        } else {
            //nextPageButton.setTitle(Localization.localized(.next), for: .normal)
        }
    }
}

