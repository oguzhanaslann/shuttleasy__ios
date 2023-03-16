import UIKit
import MapKit
import SnapKit
import FloatingPanel
import Combine

class SearchShuttleViewContoller: BaseViewController {
    private static let SEARCH_TEXT_FIELD_TAG = 2000
    
    private let searchViewModel = Injector.shared.injectSearchShuttleViewModel()
    private var searchResultCancellable : AnyCancellable? = nil
    private var destinationCancellable : AnyCancellable? = nil
    
    private let fpc = FloatingPanelController()
   
    private var debounceTimer: Timer?
    
    private let searchResultViewController = SearchResultViewController()

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
    
    
    
    
    private lazy var mapView: MKMapView =  {
        let mapView = MKMapView()
        mapView.mapType = .standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        mapView.setCenter(CLLocationCoordinate2DMake(38.4189, 27.1287), animated: true )
        mapView.delegate = self
        return mapView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = Localization.search.localized
        initViews()
        searchResultViewController.setOnSearchResultClickedListener(listener: self)
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
    }

    func setUpSearchField() {
        view.addSubview(searchField)
        searchField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(48)
        }

        searchField.delegate = self
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
    
    private func subcribeDestinationPoints() {
        destinationCancellable = searchViewModel.destinationPoints
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
                receiveValue: { [weak self] destinationPoints in
                    destinationPoints.onSuccess { destinationPointData in
                        destinationPointData.data.forEach { destinationPoint in
                            self?.mapView.addPinAt(destinationPoint)
                    }
                }
            })
    }

    private func onSearchResultUpdated(results: [SearchResult]) {
        searchResultViewController.onSearchResultUpdated(results: results)
        if fpc.state == .hidden || fpc.state == .tip {
            fpc.move(to: .half, animated: true)        
        }
    }
}

extension SearchShuttleViewContoller : UITextFieldDelegate {
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

            debounceTimer?.invalidate()

            // Set the timer to execute a method after a certain delay
            debounceTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { [weak self] timer in
                // This block will be executed after the specified delay
                // You can now safely perform any actions that should be debounced
                guard let searchText = textField.text else { return }
                self?.searchViewModel.searchShuttle(query: searchText)
            })

            return true
        }
}

extension SearchShuttleViewContoller:  SearchResultClickedListener {
    func onSearchResultClicked(result: SearchResult) {
        print(result.title)
        Navigator.shared.navigate(
            from: self,
            to: .companyDetail(
                args: CompanyDetailArgs(companyId: result.companyId)
            ),
            clearBackStack: false , 
            wrappedInNavigationController: true
        )
    }
}

extension SearchShuttleViewContoller : MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        return themedOverlayRenderer(rendererFor: overlay)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        return customPin(viewFor: annotation)
    }
        
    
    func mapViewDidFinishRenderingMap(_ mapView: MKMapView, fullyRendered: Bool) {
        if(fullyRendered) {
            subcribeDestinationPoints()
        }
    }
}
