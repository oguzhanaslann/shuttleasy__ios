import UIKit
import SnapKit
import MapKit

class PickupSelectionViewController: BaseViewController {

    lazy var enrollButton : UIButton = {
        let button = LargeButton(titleOnNormalState: Localization.enroll.localized, backgroundColor: primaryColor, titleColorOnNormalState: onPrimaryColor)
        return button
    }()
    
    
    private lazy var mapView: MKMapView =  {
        let mapView = MKMapView()
        mapView.mapType = .standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        return mapView
    }()
    
    private lazy var centerView : UIView = {
        let imageView = resImageView(name: "pinYellow")
        return imageView
    }()
    
    private let args : PickupSelectionArgs
    
    private var  pickupAreas:PickupAreas?  {
        get {
            return args.pickupAreas
        }
    }
    
    init(args : PickupSelectionArgs){
        self.args = args
        super.init(nibName: nil, bundle: nil)
    }
       
    required init(coder : NSCoder){
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
    
        view.addSubview(mapView)
        mapView.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
            mapView.setCenter(args.destinationPoint, animated: true )
        }
        initMap()

        
        view.addSubview(enrollButton)
        enrollButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.snp.bottom).offset(-32)
            make.left.equalToSuperview().offset(32)
            make.right.equalToSuperview().offset(-32)
            make.height.equalTo(largeButtonHeight)
        }
        
        view.addSubview(centerView)
        centerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    private func initMap(){
        mapView.delegate = self
        mapView.setCameraZoomRange(
            MKMapView.CameraZoomRange(minCenterCoordinateDistance: 10.0),
            animated: false
        )
        
        let region = MKCoordinateRegion(
            center: args.destinationPoint,
            latitudinalMeters: 1000,
            longitudinalMeters: 1000
        )
        
        mapView.setRegion(region, animated: true)
        
        mapView.addPinAt(args.destinationPoint)
        
        if let polygons = args.pickupAreas {
            polygons.forEach { polygon in
                mapView.addPolygon(polygon)
            }
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
        
        guard let pickupAreas = pickupAreas else {
            enrollButton.isEnabled = false
            return
        }

        for polygon in pickupAreas {
            let polygon = polygon.map { coordinate in
                return coordinate.toCGPoint()
            }
            
            let contains = center.isInside(polygon)
            
            isCenterPinInAnyArea = contains
            
            if isCenterPinInAnyArea {
                break
            }
        }
        
        enrollButton.isEnabled = isCenterPinInAnyArea
    }
}

