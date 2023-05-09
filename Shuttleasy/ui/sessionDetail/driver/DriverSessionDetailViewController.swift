//
//  DriverSessionDetailViewController.swift
//  Shuttleasy
//
//  Created by OguzhanMac on 9.05.2023.
//

import Foundation
import UIKit
import SnapKit
import MapKit

class DriverSessionDetailViewController: BaseViewController {
    
    private let passengerSessions: [SessionPassenger] = []
    
    private lazy var startSessionButton : UIButton = {
        let button = LargeButton(titleOnNormalState: Localization.startSession.localized)
        return button
    }()
    
    
    private lazy var mapView: MKMapView =  {
        let mapView = MKMapView()
        mapView.mapType = .standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        mapView.delegate = self
        return mapView
    }()
    
    
    private let flowLayout = UICollectionViewFlowLayout()
    let passengerCollectionView : BaseUICollectionView = BaseUICollectionView(
        frame: .zero,
        collectionViewLayout: .init()
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = Localization.yourRide.localized
        initViews()
    }
    
    private func initViews() {
        view.addSubview(startSessionButton)
        startSessionButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-36)
            make.left.equalToSuperview().offset(SpacingMedium)
            make.right.equalToSuperview()
                .offset(-SpacingMedium)
            make.height.equalTo(largeButtonHeight)
        }
        
        view.addSubview(mapView)
        
        view.addSubview(passengerCollectionView)
        flowLayout.scrollDirection = .horizontal
        flowLayout.itemSize = PassengerCell.itemSize
        passengerCollectionView.register(PassengerCell.self, forCellWithReuseIdentifier: PassengerCell.identifier)
        passengerCollectionView.setCollectionViewLayout(flowLayout, animated: true)
        passengerCollectionView.dataSource = self
        passengerCollectionView.delegate = self
        passengerCollectionView.isUserInteractionEnabled = true
        passengerCollectionView.snp.makeConstraints { make in 
            make.bottom.equalTo(startSessionButton.snp.top).offset(-SpacingMedium)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(PassengerCell.itemSize.height + 24)
        }
    }
    
    
    private func initMapView() {
        view.addSubview(mapView)
        mapView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
        mapView.setCameraZoomRange(MKMapView.CameraZoomRange(minCenterCoordinateDistance: 10.0), animated: false)
        let region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 41.015137, longitude: 28.979530) , // Istanbul
            latitudinalMeters: 1000,
            longitudinalMeters: 1000
        )
        mapView.setRegion(region, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        initMapView()
        view.bringSubviewToFront(startSessionButton)
        view.bringSubviewToFront(passengerCollectionView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavBackButton(navigationItem: navigationItem, target: self, action: #selector(dismissView))
    }
    
    @objc func dismissView() {
        dismiss(animated: true, completion: nil)
    }
}

extension DriverSessionDetailViewController : MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        return themedOverlayRenderer(rendererFor: overlay)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        return customPin(viewFor: annotation)
    }
}

extension DriverSessionDetailViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return passengerSessions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PassengerCell.identifier, for: indexPath) as? PassengerCell
        
        guard let cell = cell else {
            return UICollectionViewCell()
        }

        cell.configure(with: passengerSessions[indexPath.row])
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let inset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        return inset
    }
}
