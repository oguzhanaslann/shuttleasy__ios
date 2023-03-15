//
//  PickupSelectionViewController.swift
//  Shuttleasy
//
//  Created by OguzhanMac on 14.03.2023.
//

import UIKit
import SnapKit
import MapKit

class PickupSelectionViewController: BaseViewController {

    
    lazy var enrollButton : UIButton = {
        let button = LargeButton(titleOnNormalState: "Enroll", backgroundColor: primaryColor, titleColorOnNormalState: onPrimaryColor)
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
    
    let destinationPoint : CLLocationCoordinate2D
    
    init(
        destinationPoint : CLLocationCoordinate2D
    ){
        self.destinationPoint = destinationPoint
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
            mapView.setCenter(destinationPoint, animated: true )
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
            center: destinationPoint,
            latitudinalMeters: 1000,
            longitudinalMeters: 1000
        )
        
        mapView.setRegion(region, animated: true)
        
        let pin = MKPlacemark(coordinate: destinationPoint)
        mapView.addAnnotation(pin)
        
        addPolygon()
    }
    
    var points = [
        CLLocationCoordinate2DMake(38.4189, 27.1287),
        CLLocationCoordinate2DMake(38.4169, 27.1267),
        CLLocationCoordinate2DMake(38.4169, 27.1307),
    ]

    
    func addPolygon(){
        
        let polygon = MKPolygon(coordinates: &points, count: points.count)
        mapView.addOverlay(polygon)
        
        
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
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
        annotationView.canShowCallout = true
        if let image = resImage(name: "pinBlue") {
            annotationView.image = image
        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        if overlay is MKCircle {
            let renderer = MKCircleRenderer(overlay: overlay)
            renderer.fillColor = inversePrimary.withAlphaComponent(0.5)
            renderer.strokeColor = inversePrimary.withAlphaComponent(0.5)
            renderer.lineWidth = 1
            return renderer
        
        } else if overlay is MKPolyline {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = inversePrimary.withAlphaComponent(0.5)
            renderer.lineWidth = 1
            return renderer
        
        } else if overlay is MKPolygon {
            let renderer = MKPolygonRenderer(polygon: overlay as! MKPolygon)
            renderer.fillColor = inversePrimary.withAlphaComponent(0.5)
            renderer.strokeColor = inversePrimary.withAlphaComponent(0.5)
            renderer.lineWidth = 1
            return renderer
        }
        
        return MKOverlayRenderer()
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let centerPoint = mapView.centerCoordinate
        let center = CGPoint(x: centerPoint.latitude, y: centerPoint.longitude)
        
        let polygon = points.map { coordinate in
            return CGPoint(x: coordinate.latitude, y: coordinate.longitude)
        }
        let contains = containsPoint(polygon: polygon, test: center)
        print(contains)
        
        enrollButton.isEnabled = contains
    }
    
    
    func containsPoint(polygon: [CGPoint], test: CGPoint) -> Bool {
            if polygon.count <= 1 {
                return false //or if first point = test -> return true
            }

            let p = UIBezierPath()
            let firstPoint = polygon[0] as CGPoint


            p.move(to: firstPoint)

            for index in 1...polygon.count-1 {
                p.addLine(to: polygon[index] as CGPoint)
            }

            p.close()

           return p.contains(test)
        }
}
