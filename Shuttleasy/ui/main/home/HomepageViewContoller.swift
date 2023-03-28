//
//  HomepageViewContoller.swift
//  Shuttleasy
//
//  Created by Oğuzhan Aslan on 30.11.2022.
//

import UIKit
import SnapKit
import Combine

class HomepageViewContoller: BaseViewController, UITableViewDelegate {
    
    private let viewModel : HomeViewModel = Injector.shared.injectHomeViewModel()
    
    private var enrollNotificationObserver: NSObjectProtocol?
    private var profileObserver : AnyCancellable? = nil
        
    private let tableView: UITableView = BaseUITableView()

    
    private var sections: [HomeSection] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        title = Localization.home.localized
        initViews()
        viewModel.getUserProfile()
        subscribeObserves()
    }
    
    private func initViews() {
        tableView.backgroundColor = backgroundColor
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(GreetionSection.self, forCellReuseIdentifier: GreetionSection.identifier)
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview()
            make.height.equalToSuperview()
        }
    }
    
    private func subscribeObserves() {
        subscribeToEnrollNotification()
        subscribeToProfile()
    }

    private func subscribeToEnrollNotification() {
       enrollNotificationObserver = NotificationCenter.default.addObserver(
            forName: notificationNamed(.enrolled),
            object: nil,
            queue: .main
        ) { [weak self] notification in
            // Handle the notification
            print("Enrolled to shuttle")
        }
    }
    
    private func subscribeToProfile() {
        profileObserver = viewModel.userProfilePublisher
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.handleCompletion(completion)
                },
                receiveValue: { [weak self] profileState in
                    profileState.onSuccess { userProfileContent in
                        self?.addSection(
                            .greeting(userProfile: (userProfileContent.data))
                        )
                    }.onError { [weak self] error in
                        self?.showErrorSnackbar(message: error)
                    }
                }
            )
    }

    private func addSection(_ section : HomeSection) {
        
        var newSection = self.sections
        
        newSection.append(section)
        
        newSection.sort {
            $0.priority() < $1.priority()
        }
        
        
        self.sections = newSection
        tableView.reloadData()
    }
    
    deinit {
        if let enrollNotificationObserver = enrollNotificationObserver {
            NotificationCenter.default.removeObserver(enrollNotificationObserver)
        }
    }
}

extension HomepageViewContoller : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell?
        
        let section = sections[indexPath.row]
        
        switch section {
            case .greeting(let userProfile):
                let greedingCard = tableView.dequeueReusableCell(
                    withIdentifier: GreetionSection.identifier,
                    for: indexPath
                ) as? GreetionSection
                
                greedingCard?.configure(userProfile)
                
                cell = greedingCard
            case .nextSession:
                cell = UITableViewCell()
            case .upComingSessions:
                cell = UITableViewCell()
        }
        
        
        
        guard let cell = cell else { return UITableViewCell() }
        
        return cell
    }
    
}
