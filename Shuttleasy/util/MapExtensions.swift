//
//  MapExtensions.swift
//  Shuttleasy
//
//  Created by OguzhanMac on 16.03.2023.
//

import Foundation
import MapKit

extension MKMapViewDelegate {
    func customPin(viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
        
        if let image = resImage(name: "pinBlue") {
            annotationView.image = image
        }
        
        annotationView.canShowCallout = false
        return annotationView
    }
    
    
    func themedOverlayRenderer(rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let areaColor = inversePrimary.withAlphaComponent(0.5)
        let areaLineWith: CGFloat = 1

        switch overlay {
            case is MKCircle:
                let renderer = MKCircleRenderer(overlay: overlay)
                renderer.fillColor = areaColor
                renderer.strokeColor = areaColor
                renderer.lineWidth = areaLineWith
                return renderer
            case is MKPolyline:
                let renderer = MKPolylineRenderer(overlay: overlay)
                renderer.strokeColor = areaColor
                renderer.lineWidth = areaLineWith
                return renderer
            case  is MKPolygon:
                let renderer = MKPolygonRenderer(polygon: overlay as! MKPolygon)
                renderer.fillColor = areaColor
                renderer.strokeColor = areaColor
                renderer.lineWidth = areaLineWith
                return renderer
            default :
                return MKOverlayRenderer()
        }
    }
    
    
}

extension MKMapView {
    func addPolygon(_ polygon: [CLLocationCoordinate2D]) {
        let polygon = MKPolygon(coordinates: polygon, count: polygon.count)
        addOverlay(polygon)
    }
    
    func addPinAt(_ coordinate: CLLocationCoordinate2D) {
        let pin = MKPlacemark(coordinate: coordinate)
        self.addAnnotation(pin)
    }
    
    func addPinAt(_ point: CGPoint) {
        addPinAt(point.toCoordinate())
    }

    func hasPinAt(_ coordinate: CLLocationCoordinate2D) -> Bool {
        return annotations.filter(
                { $0 is MKPlacemark }
            ).contains(
                where: { 
                    ($0 as! MKPlacemark).coordinate.compareTo(coordinate) 
                }
            )
    }

    func moveCenterTo(_ coordinate: CLLocationCoordinate2D) {
        let latitudinalMetersOfMap = region.span.latitudeDelta * 111000
        let longitudinalMetersOfMap = region.span.longitudeDelta * 111000 * cos(region.center.latitude * .pi / 180) // One degree of longitude is approximately 111,000 meters at the equator, but less at other latitudes
        let region = MKCoordinateRegion(
            center: coordinate,
            latitudinalMeters: latitudinalMetersOfMap,
            longitudinalMeters: longitudinalMetersOfMap
        )
        setRegion(region, animated: true)
    }

    
}

extension CLLocationCoordinate2D  {
    func toCGPoint() -> CGPoint {
        return CGPoint(x: latitude, y: longitude)
    }

    func compareTo(_ coordinate: CLLocationCoordinate2D) -> Bool {
        return latitude == coordinate.latitude && longitude == coordinate.longitude
    }
}

extension CGPoint {
    func isInside(_ polygon : [CGPoint]) -> Bool {
        if polygon.count <= 1 {
            return false //or if first point = test -> return true
        }
        
        let path = getUIBezierPath(from: polygon)
        
        return path.contains(self)
    }
    
    private func getUIBezierPath(from polygon : [CGPoint]) -> UIBezierPath {
        let path = UIBezierPath()
        let firstPoint = polygon[0] as CGPoint
        path.move(to: firstPoint)
        for index in 1...polygon.count-1 {
            path.addLine(to: polygon[index] as CGPoint)
        }

        path.close()

        return path
    }
    
    func toCoordinate() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: x, longitude: y)
    }
}

