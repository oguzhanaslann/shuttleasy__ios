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

class SessionDetailViewController: BaseViewController {
    
    let sessionStateView = SessionStateView()
    
    private let fpc = FloatingPanelController()
    
    private let controlViewController = SessionControllerViewController()
    
    private lazy var mapView: MKMapView =  {
        let mapView = MKMapView()
        mapView.mapType = .standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        mapView.delegate = self
        return mapView
    }()
    
    override func viewDidLoad() {
        title = Localization.yourRide.localized
        view.addSubview(sessionStateView)
        sessionStateView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            make.right.equalToSuperview().offset(-16)
            sessionStateView.layoutIfNeeded()
        }
        
        sessionStateView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapSessionStateView)))

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
}

extension SessionDetailViewController : MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        return themedOverlayRenderer(rendererFor: overlay)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        return customPin(viewFor: annotation)
    }
}
