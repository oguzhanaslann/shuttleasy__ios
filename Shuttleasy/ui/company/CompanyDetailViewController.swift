//
//  CompanyDetailViewController.swift
//  Shuttleasy
//
//  Created by OguzhanMac on 19.02.2023.
//

import UIKit
import MaterialComponents.MaterialTabs_TabBarView
import SnapKit
import Combine
import MapKit

class CompanyDetailViewController: BaseViewController {
    private static let ABOUT_PAGE_INDEX = 0
    private static let SHUTTLES_PAGE_INDEX = 1
    
    private static let HEADER_PHOTO_TAG = 6607
    private static let HEADER_COMPANY_NAME_TAG = 4241
    private static let HEADER_COMPANY_SLOGAN_TAG = 8573
    private static let HEADER_COMPANY_RATING_TAG = 4049

    private let viewModel : CompanyDetailViewModel = Injector.shared.injectCompanyDetailViewModel()
    
    let args : CompanyDetailArgs
    
    private var companyDetailObserver: AnyCancellable? = nil

    init(args : CompanyDetailArgs){
        self.args  = args
        super.init(nibName: nil, bundle: nil)
    }
       
    required init(coder : NSCoder){
        fatalError()
    }

    lazy var imageContainer = {
        let imageContainer = UIView()
        
        let image = UIImageView(image : UIImage(named: "shuttle_placeholder"))
        imageContainer.addSubview(image)
       
        image.layer.backgroundColor = UIColor.gray.cgColor
        
        image.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
        }
            
        image.addoverlay(alpha: 0.33)
        
        image.tag = CompanyDetailViewController.HEADER_PHOTO_TAG
        
        return imageContainer
    }()
    
    lazy var companyHeader = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        
        let companyNameTitle = HeadlineSmall(text: "Header", color: .white)
        companyNameTitle.breakLineFromEndIfNeeded()
        companyNameTitle.tag = CompanyDetailViewController.HEADER_COMPANY_NAME_TAG
        
        
        let companyShortSlogan = LabelMedium(text: "slogan", color: .white)
        companyShortSlogan.breakLineFromEndIfNeeded()
        companyShortSlogan.tag = CompanyDetailViewController.HEADER_COMPANY_SLOGAN_TAG
        
        stackView.addArrangedSubview(companyNameTitle)
        stackView.addArrangedSubview(companyShortSlogan)

        return stackView
    }()

    lazy var pointBadgeView = {
        let badge = ratingBadgeView(
            rating: 0,
            totalRatings: 0,
            ratingsTag: CompanyDetailViewController.HEADER_COMPANY_RATING_TAG
        )
        
        badge.layer.maskedCorners = [.layerMinXMinYCorner]
        
        return badge
    }()
    
    
    let imageHeight = 200

    lazy var enrollButton : UIButton = {
        let button = LargeButton(
            titleOnNormalState: "Enroll",
            backgroundColor: primaryColor,
            titleColorOnNormalState: onPrimaryColor
        )
        
        button.setOnClickListener {
            Navigator.shared.navigate(from: self, to: Destination.picksessions(
                args: PickSessionsArgs(
                    companyId: self.args.companyId,
                    destinationPoint: self.args.destinationPoint,
                    sessionPickModel: self.args.sessionPickModel
                    )
                )
            )
        }
        return button
    }()
    
    private func safeAreaHeight() -> CGFloat {
        let guide = self.view.safeAreaLayoutGuide
        return guide.layoutFrame.size.height
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
        viewModel.getCompanyDetail(companyId: self.args.companyId)
        subscribeObservers()
    }
    
    private func initViews() {
        initHeaderSection()
        initAboutView()
        
        view.addSubview(enrollButton)
        enrollButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.snp.bottom).offset(-32)
            make.left.equalToSuperview().offset(32)
            make.right.equalToSuperview().offset(-32)
            make.height.equalTo(largeButtonHeight)
        }
    }
    
    private func initHeaderSection() {
        view.addSubview(imageContainer)
        imageContainer.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(imageHeight)
        }
        
        view.addSubview(pointBadgeView)
        pointBadgeView.snp.makeConstraints { make in
            view.bringSubviewToFront(pointBadgeView)
            make.bottom.equalTo(imageContainer.snp.bottom)
            make.width.equalTo(105)
            make.height.equalTo(28)
            make.right.equalToSuperview()
        }

        view.addSubview(companyHeader)
        companyHeader.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(24)
            make.bottom.equalTo(imageContainer.snp.bottom).inset(16)
            make.right.lessThanOrEqualTo(pointBadgeView.snp.left).inset(8)
        }
    }
    
    private func initAboutView() {
        let aboutView = CompanyAboutView(viewModel: viewModel)
        view.addSubview(aboutView)
        aboutView.snp.makeConstraints { make in
            make.top.equalTo(imageContainer.snp.bottom)
            make.bottom.equalTo(view.snp.bottom)
            make.left.right.equalToSuperview()
        }
    }

    private func subscribeObservers() {
        companyDetailObserver = viewModel.companyDetailPublisher
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: {[weak self] completion in
                    self?.handleCompletion(completion)
                },
                receiveValue: { [weak self] result in
                    result.onSuccess { data in
                        print(data)
                        self?.onCompanyDetailResult(data.data)
                    }.onError { errorMessage in
                        self?.showErrorSnackbar(message: errorMessage)
                    }
                }
            )
    }
    
    private func onCompanyDetailResult(_ companyDetail : CompanyDetail) {
        setHeaderSection(with: companyDetail)
        
    }
    
    private func setHeaderSection(with companyDetail : CompanyDetail) {
        let headerPhotoView = getHeaderPhotoView()
        headerPhotoView.load(url: companyDetail.thumbnail)
        let companyNameHeader = getCompanyNameHeader()
        companyNameHeader.text = companyDetail.name
        let companySlogan = getCompanySlogan()
        companySlogan.text = companyDetail.slogan
        let companyRatings = getCompanyRatings()
        companyRatings.text = "\(companyDetail.rating) (\(companyDetail.totalRating))"
    }
    
    private func getHeaderPhotoView() -> UIImageView {
        return self.view.viewWithTag(CompanyDetailViewController.HEADER_PHOTO_TAG) as! UIImageView
    }

    private func getCompanyNameHeader() -> UILabel {
        return self.view.viewWithTag(CompanyDetailViewController.HEADER_COMPANY_NAME_TAG) as! UILabel
    }

    private func getCompanySlogan() -> UILabel {
        return self.view.viewWithTag(CompanyDetailViewController.HEADER_COMPANY_SLOGAN_TAG) as! UILabel
    }

    private func getCompanyRatings() -> UILabel {
        return self.view.viewWithTag(CompanyDetailViewController.HEADER_COMPANY_RATING_TAG) as! UILabel
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
