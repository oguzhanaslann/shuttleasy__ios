
import UIKit
import SnapKit
import MapKit
import Combine


class PickupSelectionViewController: BaseViewController {
    
    private let viewModel = Injector.shared.injectPickupSelectionViewModel()
    private var pickUpAreas : AnyCancellable? = nil
    private var enrollObserver : AnyCancellable? = nil

    lazy var enrollButton : UIButton = {
        let button = LargeButton(
            titleOnNormalState: Localization.enroll.localized
        )
        button.isEnabled = false
        return button
    }()
    
    private lazy var mapView: MKMapView =  {
        let mapView = MKMapView()
        mapView.mapType = .standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        return mapView
    }()
    
    private lazy var pickLocationView : UIView = {
        let imageView = resImageView(name: "pinYellow")
        return imageView
    }()
    
    private let args : PickupSelectionArgs
    
    init(args : PickupSelectionArgs){
        self.args = args
        super.init(nibName: nil, bundle: nil)
    }
       
    required init(coder : NSCoder){
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
        subscribeObservers()
        viewModel.getPickupAreasOf(
            destinationPoint: args.destinationPoint,
            sessionPickModel: args.sessionPickModels
        )
    }
       
    private func initViews() {
        initMap()
        initEnrollButton()
        putPickLocationViewToCenter()
    }
    
    private func putPickLocationViewToCenter() {
        view.addSubview(pickLocationView)
        pickLocationView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    private func initMap(){
        view.addSubview(mapView)
        
        mapView.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
            mapView.setCenter(args.destinationPoint.toCoordinate(), animated: true )
        }
        
        mapView.delegate = self
        mapView.setCameraZoomRange(
            MKMapView.CameraZoomRange(minCenterCoordinateDistance: 10.0),
            animated: false
        )
        
        let region = MKCoordinateRegion(
            center: args.destinationPoint.toCoordinate(),
            latitudinalMeters: 1000,
            longitudinalMeters: 1000
        )
        
        mapView.setRegion(region, animated: true)
        
        mapView.addPinAt(args.destinationPoint)
    }
    

    private func initEnrollButton() {
        view.addSubview(enrollButton)
        enrollButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.snp.bottom).offset(-32)
            make.left.equalToSuperview().offset(32)
            make.right.equalToSuperview().offset(-32)
            make.height.equalTo(largeButtonHeight)
        }
        
        enrollButton.setOnClickListener {
            self.viewModel.enrollUserToCompanySessions(
                pickUpPoint: self.mapView.centerCoordinate.toCGPoint()
            )
        }
    }
    
    private func subscribeObservers() {
        subscribeToPickUpAreas()
        subscribeToEnrollObserver()
    }
    
    private func subscribeToPickUpAreas() {
        pickUpAreas = viewModel.pickupAreaPublished
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: {[weak self] completion in
                self?.handleCompletion(completion)
            }, receiveValue: { pickUpState in
                pickUpState.onSuccess {[weak self] data in
                    self?.drawDestinationPoints(pickupAreas: data.data)
                }
            })
    }
    
    private func drawDestinationPoints(pickupAreas: [PickupArea]) {
        pickupAreas.forEach { pickupArea in
            let polygon = pickupArea.polygon.map { point in
                point.toCoordinate()
            }
            
            mapView.addPolygon(polygon)
        }
    }
    
    private func subscribeToEnrollObserver() {
        enrollObserver = viewModel.enrollEventPublished
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: {[weak self] completion in
                self?.handleCompletion(completion)
            }, receiveValue: { enrollState in
                    enrollState.onSuccess {[weak self] data in
                        self?.navigateToSessionPick(
                            enrolledSessionIds: data.data.enrolledSessionIds,
                            pickUpPoint: data.data.pickUpPoint
                        )
                    }.onError {[weak self] error in
                        self?.showErrorSnackbar(message: error)
                    }
                }
            )
    }
    
    private func navigateToSessionPick(enrolledSessionIds: [Int], pickUpPoint: CGPoint) {
        Navigator.shared.navigate(
            from: self,
            to: .picksessions(
                args: PickSessionsArgs(
                    companyId: args.companyId,
                    pickUpPoint: pickUpPoint,
                    sessionPickModel: getSessionPickListModel(enrolledSessionIds)
                )
            )
        )
    }
    
    private func getSessionPickListModel(_ enrolledSessionIds : [Int])  -> [SessionPickListModel]{
        return args.sessionPickModels.map { model in
            return SessionPickListModel(
                dayName: model.dayName,
                sessionPickList: model.sessionPickList.filter { enrolledSessionIds.contains($0.sessionId) }
            )
        }.filter { sessionPickModel in
            !sessionPickModel.sessionPickList.isEmpty
        }
    }
    
    override func shouldSetStatusBarColor() -> Bool {
        return false
    }
    
    
    override func getNavigationBarBackgroundColor() -> UIColor {
        return .clear
    }
    
    override func getNavigationBarTintColor() -> UIColor {
        return .black
    }
}

extension PickupSelectionViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        return customPin(viewFor: annotation)
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        return themedOverlayRenderer(rendererFor: overlay)
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let centerPoint = mapView.centerCoordinate
        let center = centerPoint.toCGPoint()

        
        var isCenterPinInAnyArea = false
        
        let pickupAreas = viewModel.getCurrentPickupAreas()
        
        guard let pickupAreas = pickupAreas else {
            enrollButton.isEnabled = false
            return
        }

        for pickupArea in pickupAreas {
            let polygon = pickupArea.polygon
            let contains = center.isInside(polygon)
            
            isCenterPinInAnyArea = contains
            
            if isCenterPinInAnyArea {
                break
            }
        }
        
        enrollButton.isEnabled = isCenterPinInAnyArea
    }
}
