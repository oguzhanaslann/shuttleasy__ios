//
//  NextSessionCell.swift
//  Shuttleasy
//
//  Created by OguzhanMac on 28.03.2023.
//

import Foundation
import UIKit
import SnapKit
import MapKit

class NextSessionCell : BaseTableViewCell {
    
    static let identifier = "NextSessionCell"
    
    private static let PLATE_NUMBER_ID = 0
    private static let MAP_ID = 1
    
    private let titleLabel = TitleLarge(
        text: Localization.yourNextSessions.localized,
        color: onBackgroundColor
    )
    
    private lazy var nextSessionCard : UIView = {
        let containerCard = UIView()
        
        let mapView = MKMapView()
        mapView.mapType = .standard
        mapView.isZoomEnabled = false
        mapView.isScrollEnabled = false
        mapView.isUserInteractionEnabled = false
        mapView.tag = NextSessionCell.MAP_ID
        mapView.delegate = self
        
        mapView.setCameraZoomRange(
            MKMapView.CameraZoomRange(minCenterCoordinateDistance: 10.0),
            animated: false
        )

        containerCard.addSubview(mapView)
        mapView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(99)
        }
        mapView.backgroundColor = .lightGray
    
        containerCard.backgroundColor = primaryContainer
        containerCard.layer.cornerRadius = roundedLargeCornerRadius
        containerCard.layer.masksToBounds = true
        return containerCard
    }()
    
    
    func getBadgeView(with text : String) -> UIView{
        let badgeView = UIView()
        badgeView.backgroundColor = primaryContainer
        badgeView.layer.cornerRadius = roundedMediumCornerRadius
        
        let textLabel = LabelMedium(text: text, color: onPrimaryContainer)
        textLabel.tag = NextSessionCell.PLATE_NUMBER_ID
        badgeView.addSubview(textLabel)
        
        textLabel.snp.makeConstraints { make in
            make.left.greaterThanOrEqualToSuperview().offset(8)
            make.right.lessThanOrEqualToSuperview().offset(-8)
            make.top.greaterThanOrEqualToSuperview().offset(4)
            make.bottom.lessThanOrEqualToSuperview().offset(4)
            make.center.equalToSuperview()
        }
        
        return badgeView
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initViews()
    }
    
    private func initViews() {
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.left.equalToSuperview().offset(24)
            make.right.lessThanOrEqualToSuperview().offset(-24)
            make.height.greaterThanOrEqualTo(28)
        }
        
        contentView.addSubview(nextSessionCard)
        nextSessionCard.snp.makeConstraints { make in
            make.top.greaterThanOrEqualTo(titleLabel.snp.bottom).offset(8)
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
            make.height.equalTo(256)
        }

        contentView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.greaterThanOrEqualTo(16 + 28 + 256 + 12  )
        }
    }
    
//    override func systemLayoutSizeFitting(
//        _ targetSize: CGSize,
//        withHorizontalFittingPriority _: UILayoutPriority,
//        verticalFittingPriority _: UILayoutPriority
//    ) -> CGSize {
//        tableView.frame = CGRect(x: 0, y: 0, width: targetSize.width, height: 1000)
//        tableView.reloadData()
//        tableView.layoutIfNeeded()
//
//        let contentSize = tableView.contentSize
//        collectionItemSize = contentSize.height
//
//        tableView.snp.updateConstraints {
//            $0.top.leading.trailing.equalToSuperview()
//            $0.bottom.equalTo(-16)
//            $0.height.equalTo(self.collectionItemSize)
//        }
//
//        return super.systemLayoutSizeFitting(
//            targetSize,
//            withHorizontalFittingPriority: .required,
//            verticalFittingPriority: .fittingSizeLevel
//        )
//    }
    
    func configure(_ model : NextSessionModel) {
        let badgeView = getBadgeView(with: model.sessionBusPlateNumber)
        nextSessionCard.addSubview(badgeView)
        badgeView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.right.equalToSuperview().offset(-16)
            make.height.equalTo(36)
            make.width.equalTo(108)
        }
        
        
        let destinationSection = createCardSection(
            title: model.destinationName,
            subtitle: "Destination",
            resImageName: "icCity"
        )
        
        nextSessionCard.addSubview(destinationSection)

        if let mapView = getMapView() {
            destinationSection.snp.makeConstraints { make in
                make.top.equalTo(mapView.snp.bottom).offset(12)
                make.left.equalToSuperview().offset(24)
                make.right.equalToSuperview().offset(-24)
                make.height.greaterThanOrEqualTo(34)
            }

            let region = MKCoordinateRegion(
                center: model.destinationLocation.toCoordinate(),
                latitudinalMeters: 500,
                longitudinalMeters: 500
            )
            mapView.setRegion(region, animated: false)
            mapView.addPinAt(model.destinationLocation.toCoordinate())
        }
    
        let startTime = createCardSection(
            title: ShuttleasyDateFormatter.shared.convertDate(
               date:  model.startDate,
               targetFormat: "HH:mm  - dd/MM/yyyy"
            ),
            subtitle: "Start Time",
            resImageName: "icCalendar"
        )

        nextSessionCard.addSubview(startTime)
        startTime.snp.makeConstraints { make in
            make.top.greaterThanOrEqualTo(destinationSection.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
            make.height.greaterThanOrEqualTo(34)
        }
    }
    
    private func getPlateNumberLabel() -> UILabel? {
        return nextSessionCard.viewWithTag(NextSessionCell.PLATE_NUMBER_ID) as? UILabel
    }

    private func getMapView() -> MKMapView? {
        return nextSessionCard.viewWithTag(NextSessionCell.MAP_ID) as? MKMapView
    }
}

extension NextSessionCell: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        return customPin(viewFor: annotation)
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        return themedOverlayRenderer(rendererFor: overlay)
    }
}

struct NextSessionModel {
    let sessionId: Int
    let sessionBusPlateNumber: String
    let destinationName : String
    let startDate: Date
    let startLocation: CGPoint
    let destinationLocation: CGPoint
}
