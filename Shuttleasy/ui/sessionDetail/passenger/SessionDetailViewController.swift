//
//  SessionDetailViewController.swift
//  Shuttleasy
//
//  Created by OguzhanMac on 18.04.2023.
//

import Foundation
import UIKit
import SnapKit
import FloatingPanel
import MapKit
import Combine


class SessionDetailViewController: BaseViewController {
    
    private let viewModel: SessionDetailViewModel = Injector.shared.injectSessionDetailViewModel()
    private var sessionDetailObserver : AnyCancellable? = nil
    
    let sessionStateView = SessionStateView()
    
    private let fpc = FloatingPanelController()
    
    private var controlViewController: SessionControllerViewController

    private var args : SessionDetailArgs
    
    init(args : SessionDetailArgs){
        self.args  = args
        controlViewController = SessionControllerViewController(viewModel: viewModel)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init(coder : NSCoder){
        fatalError()
    }
    
    private lazy var mapView: MKMapView =  {
        let mapView = MKMapView()
        mapView.mapType = .standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        mapView.delegate = self
        return mapView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = Localization.yourRide.localized
        viewModel.getSessionDetail(sessionId: args.sessionId)
        view.addSubview(sessionStateView)
        sessionStateView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(SpacingMedium)
            make.right.equalToSuperview().offset(-16)
            sessionStateView.layoutIfNeeded()
        }
        
        sessionStateView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapSessionStateView)))
        subcribeObservers()
    }
    
    private func subcribeObservers() {
         sessionDetailObserver = viewModel.sessionDetailPublisher
            .receive(on: DispatchQueue.main)
            .sink (
                receiveCompletion: { _ in},
                receiveValue: {[weak self] sessionDetailDataState in
                    sessionDetailDataState.onSuccess {
                        let sessionDetail = $0.data.sessionDetail
                        let sessionState = $0.data.sessionState
                        self?.sessionStateView.setState(state: sessionState)
                    }
                }
        )
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if(animated) {
            initMapView()
            view.bringSubviewToFront(sessionStateView)
            setUpFloatingPanel()
        }
    }

    private func initMapView() {
        view.addSubview(mapView)
        mapView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        mapView.setCameraZoomRange(MKMapView.CameraZoomRange(minCenterCoordinateDistance: 10.0), animated: false)
        let region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 41.015137, longitude: 28.979530) , // Istanbul
            latitudinalMeters: 1000,
            longitudinalMeters: 1000
        )
        mapView.setRegion(region, animated: true)
    }
    
    private func setUpFloatingPanel() {
        fpc.addPanel(toParent: self)
        fpc.set(contentViewController: controlViewController)
        let appearance = SurfaceAppearance()
        appearance.cornerRadius = roundedMediumCornerRadius
        fpc.surfaceView.appearance = appearance
        fpc.move(to: .tip, animated: false)
    }

    @objc func didTapSessionStateView() {
        let sessionState = SessionState.completed
        sessionStateView.setState(state: sessionState)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavBackButton(navigationItem: navigationItem, target: self, action: #selector(dismissView))
    }
    
    @objc func dismissView() {
        Navigator.shared.popBack(from: self)
    }

    deinit {
        sessionDetailObserver?.cancel()
        sessionDetailObserver = nil
    }

}

extension SessionDetailViewController : MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        return themedOverlayRenderer(rendererFor: overlay)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        return customPin(viewFor: annotation)
    }
}
