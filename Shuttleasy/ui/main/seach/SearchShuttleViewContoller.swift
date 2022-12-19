//
//  SearchShuttleViewContoller.swift
//  Shuttleasy
//
//  Created by Oğuzhan Aslan on 30.11.2022.
//

import UIKit
import MapKit
import SnapKit
import FloatingPanel
import Combine

class SearchShuttleViewContoller: BaseViewController {

    private let searchViewModel = Injector.shared.injectSearchShuttleViewModel()
    private var searchResultCancellable : AnyCancellable? = nil
    private let fpc = FloatingPanelController()
    
    private static let SEARCH_TEXT_FIELD_TAG = 2000
   
    var cancellable = [AnyCancellable]()
    
    
    private lazy var searchField : UITextField = {
        let searchField = UITextField()
        searchField.layer.cornerRadius = roundedMediumCornerRadius
        searchField.layer.masksToBounds = true
        searchField.backgroundColor = .white
        searchField.placeholder = "Search"
        searchField.font = BodyMediumFont()

        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 36, height: 30))
        let magnifierIcon = UIImage(named: "magnifier")
        let magnifierImageView = systemImage(systemName: "magnifyingglass")
        magnifierImageView.frame = CGRect(x: 8, y: 5, width: 20, height: 20)  // set the frame of the image view
        paddingView.addSubview(magnifierImageView)  // add the image view as a subview of the padding view
        magnifierImageView.tintColor = .black.withAlphaComponent(0.5)
        magnifierImageView.contentMode = .center
        searchField.leftView = paddingView
        searchField.leftViewMode = .always

        searchField.tag = SearchShuttleViewContoller.SEARCH_TEXT_FIELD_TAG

        return searchField
    }()
    
    
    private let searchResultViewController = SearchResultViewController()
    
    private lazy var mapView: MKMapView =  {
        let mapView = MKMapView()

        mapView.mapType = .standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        mapView.setCenter(CLLocationCoordinate2DMake(38.4189, 27.1287), animated: true )
    
        return mapView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Search"
        initViews()
        subscribeObservers()
    }
    
    func initViews() {
        setUpMapView()
        setUpSearchField()
        setUpFloatingPanel()
    }
    
    func setUpMapView() {
        view.addSubview(mapView)

        mapView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        mapView.setCameraZoomRange(MKMapView.CameraZoomRange(minCenterCoordinateDistance: 10.0), animated: false)
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 38.4189, longitude: 27.1287), latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(region, animated: true)

        // map gesture recognizer 
        // let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
    }

 

    func setUpSearchField() {
        view.addSubview(searchField)
        searchField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(48)
        }

    
        let publisher = NotificationCenter.default.publisher(for: UISearchTextField.textDidChangeNotification, object: searchField)
        publisher
            .map {
                ($0.object as! UITextField).text
            } 
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .sink(
                receiveValue: { [weak self] (value) in
                    guard let searchText = self?.searchField.text else { return }
                    self?.searchViewModel.searchShuttle(query: searchText)
                }
            )
            .store(in: &cancellable)
    }

    func setUpFloatingPanel() {
        fpc.addPanel(toParent: self)
        fpc.set(contentViewController: searchResultViewController)
        fpc.track(scrollView: searchResultViewController.tableView)
        let appearance = SurfaceAppearance()
        appearance.cornerRadius = roundedMediumCornerRadius
        fpc.surfaceView.appearance = appearance
        fpc.move(to: .tip, animated: false)
    }


    func subscribeObservers() {
        searchResultCancellable = searchViewModel.searchResultsPublisher
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    switch completion {
                        case .failure(let error):
                            print(error)
                            self?.showErrorSnackbar(message: error.localizedDescription)
                        case .finished:
                            print("finished")
                            break
                        }
                }, 

                receiveValue: { [weak self] searchState in
                    searchState.onLoading {
                        self?.onSearchResultUpdated(results: [])
                    }.onSuccess { data in
                        self?.onSearchResultUpdated(results: data.data)
                    }.onError { error in
                        self?.onSearchResultUpdated(results: [])
                        self?.showErrorSnackbar(message: error)
                    }
                }
            )
    }

    private func onSearchResultUpdated(results: [SearchResult]) {
        searchResultViewController.onSearchResultUpdated(results: results)
        if fpc.state == .hidden || fpc.state == .tip {
            fpc.move(to: .half, animated: true)        
        }
        
    }
}
