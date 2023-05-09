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
    private var nextSessionObserver : AnyCancellable? = nil
    private var upComingSessionObserver : AnyCancellable? = nil
        
    private let tableView: UITableView = BaseUITableView()

    private var sections: [HomeSection] = []
        
    override func viewDidLoad() {
        super.viewDidLoad()
        title = Localization.home.localized
        initViews()
        viewModel.getUserProfile()
        viewModel.getActiveSessions()
        subscribeObserves()
    }
    
    private func initViews() {
        tableView.backgroundColor = backgroundColor
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(GreetionSection.self, forCellReuseIdentifier: GreetionSection.identifier)
        tableView.register(NextSessionCell.self, forCellReuseIdentifier: NextSessionCell.identifier)
        tableView.register(HeaderCell.self, forCellReuseIdentifier: HeaderCell.identifier)
        tableView.register(UpComingCell.self, forCellReuseIdentifier: UpComingCell.identifier)
        tableView.register(EmptySessionCell.self, forCellReuseIdentifier: EmptySessionCell.identifier)
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
        subscribeToNextSession()
        subscribeToActiveSessions()
    }

    private func subscribeToEnrollNotification() {
       enrollNotificationObserver = NotificationCenter.default.addObserver(
            forName: notificationNamed(.enrolled),
            object: nil,
            queue: .main
        ) { [weak self] notification in
            self?.viewModel.getActiveSessions()
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
        
        if newSection.contains(where: { return containsAnyUpcommingSession($0)}){
            if !newSection.contains(.upComingSessionHeader) {
                newSection.append(.upComingSessionHeader)
            }
        } else {
            newSection.removeAll(where: { $0 == .upComingSessionHeader })
        }
                
        updateSessionSection(&newSection)
        
        self.sections = newSection
        tableView.reloadData()
    }
    
    
    private func updateSessionSection(_ sections: inout [HomeSection]) {
        if sections.filter({ $0.isSessionSection() }).isEmpty {
            sections.append(.noSession)
        } else {
            sections.removeAll(where: { $0 == .noSession })
        }
        

        sections.sort {
            $0.priority() < $1.priority()
        }
    }
    
    private func containsAnyUpcommingSession(_ section: HomeSection) -> Bool {
        if case .upComingSessions = section { return true } else { return false }
    }
    

    private func subscribeToNextSession() {
        nextSessionObserver = viewModel.nextSessionPublisher
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.handleCompletion(completion)
                },
                receiveValue: { [weak self] nextSession in
                    self?.addSection(
                        .nextSession(nextSessionModel: nextSession.toNextSessionModel())
                    )
                }
            )
    }
        

    private func subscribeToActiveSessions() {
        upComingSessionObserver = viewModel.upComingSessionsPublisher
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.handleCompletion(completion)
                },
                receiveValue: { [weak self] upComingSession in
                    upComingSession.forEach {
                        self?.addSection(
                            .upComingSessions(
                                upComingSessions: $0.toUpComingSessionModel()
                            )
                        )
                    }
                }
            )
    }

    deinit {
        if let enrollNotificationObserver = enrollNotificationObserver {
            NotificationCenter.default.removeObserver(enrollNotificationObserver)
        }
    }
}

extension ActiveSession {
    func toNextSessionModel() -> NextSessionModel {
        return NextSessionModel(
            sessionId: sessionId,
            sessionBusPlateNumber: plateNumber,
            destinationName: destinationName,
            startDate: startDate,
            startLocation: startLocation,
            destinationLocation: endLocation,
            totalPassengers: totalPassengers,
            passengerCapacity: passengerCapacity
        )
    }

    func toUpComingSessionModel() -> UpComingSessionModel {
        return UpComingSessionModel(
            sessionId: sessionId,
            sessionBusPlateNumber: plateNumber,
            destinationName: destinationName,
            startDate: startDate
        )
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
            case .nextSession(let nextSessionModel):
                let nextSessionCell = tableView.dequeueReusableCell(
                    withIdentifier: NextSessionCell.identifier,
                    for: indexPath
                ) as? NextSessionCell
                
                nextSessionCell?.configure(nextSessionModel)
                
                cell = nextSessionCell
            case .upComingSessionHeader:
                let headerCell  = tableView.dequeueReusableCell(
                    withIdentifier: HeaderCell.identifier,
                    for: indexPath
                ) as? HeaderCell

                headerCell?.setTitle(Localization.upCommingSessions.localized)
                
                cell = headerCell
            case .upComingSessions(let upComingSessions):
                let upComingCell = tableView.dequeueReusableCell(
                    withIdentifier: UpComingCell.identifier,
                    for: indexPath
                ) as? UpComingCell
                
                upComingCell?.configure(upComingSessions)
                
                cell = upComingCell
            
            case .noSession:
                let headerCell  = tableView.dequeueReusableCell(
                    withIdentifier: EmptySessionCell.identifier,
                    for: indexPath
                ) as? EmptySessionCell

                cell = headerCell
            }

        guard let cell = cell else { return UITableViewCell() }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = sections[indexPath.row]
        switch section {
            case .nextSession(let nextSessionModel):
            
                let userProfile = viewModel.getCurrentProfile()
                let userProfileType = userProfile?.profileType
                print( userProfileType)

                if case .driver = userProfileType {
                    Navigator.shared.navigate(
                        from: self,
                        to: .driverSessionDetail,
                        clearBackStack: false,
                        wrappedInNavigationController: true
                    )
                } else if case .passenger = userProfileType {
                    Navigator.shared.navigate(
                        from: self,
                        to: .passengerSessionDetail(args: .init(sessionId: nextSessionModel.sessionId))
                    )
                } else {
                    debugPrint("Unknown profile type \(userProfileType)")
                }
            default:
                break
        }
    }    
}
