//
//  CompanyShuttlesCell.swift
//  Shuttleasy
//
//  Created by OguzhanMac on 1.03.2023.
//

import Foundation
import UIKit

class CompanyShuttleCell: UITableViewCell {
    static let identifier = "CompanyShuttleCell"
    
    let shuttleImage =  UIImageView(image : UIImage(named: "shuttle_placeholder"))
    let shuttleRoute = TitleSmall(text: "Konak Pier - Yaşar University")
    let enrollButton = LabelSmall(text: "Enroll", color : primaryColor)
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        transparentBackground()
        
        addSubview(shuttleImage)
        shuttleImage.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(SpacingMedium)
            make.left.equalToSuperview().offset(SpacingMedium)
            make.bottom.equalToSuperview().offset(-SpacingMedium)
            make.size.equalTo(90)
            shuttleImage.layer.cornerRadius = CGFloat(SHAPE_MEDIUM)
            shuttleImage.layer.masksToBounds = true
        }
        
        
        addSubview(shuttleRoute)
        shuttleRoute.snp.makeConstraints { make in
            make.left.equalTo(shuttleImage.snp.right).offset(SpacingXSmall)
            make.top.equalToSuperview().offset(SpacingMedium)
            make.right.lessThanOrEqualToSuperview().offset(-SpacingXSmall)
        }
        
        
        let plateNumber = shuttleDetailView(resImageName: "icPhone", text: "35 SE 99")
        addSubview(plateNumber)
        plateNumber.snp.makeConstraints { make in
            make.top.equalTo(shuttleRoute.snp.bottom).offset(SpacingXSmall)
            make.left.equalTo(shuttleImage.snp.right).offset(SpacingXSmall)
            make.right.lessThanOrEqualToSuperview().offset(-SpacingXSmall)
        }
        
        
        let shuttleSchedule = shuttleDetailView(resImageName: "icPhone", text: "Mon/Tue/Wen : 12:30")
        addSubview(shuttleSchedule)
        shuttleSchedule.snp.makeConstraints { make in
            make.top.equalTo(plateNumber.snp.bottom).offset(SpacingSmall)
            make.left.equalTo(shuttleImage.snp.right).offset(SpacingXSmall)
            make.right.lessThanOrEqualToSuperview().offset(-SpacingXSmall)
        }
        
        
        let driverName = shuttleDetailView(resImageName: "icPhone", text: "John doe", contentColor : neutral60)
        addSubview(driverName)
        driverName.snp.makeConstraints { make in
            make.top.equalTo(shuttleSchedule.snp.bottom).offset(SpacingSmall)
            make.left.equalTo(shuttleImage.snp.right).offset(SpacingXSmall)
            make.right.lessThanOrEqualToSuperview().offset(-SpacingXSmall)
        }
        
        
        
        addSubview(enrollButton)
        enrollButton.layer.borderColor = primaryColor.cgColor
        enrollButton.layer.borderWidth = 1
        enrollButton.layer.cornerRadius = 8
        enrollButton.textAlignment = .center
        enrollButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-28)
            make.height.equalTo(24)
            make.width.equalTo(56)
            make.bottom.equalToSuperview().offset(-SpacingMedium)
        }
        
    }
    
    private func shuttleDetailView(
        resImageName: String,
        text : String,
        contentColor : UIColor = onBackgroundColor
    ) -> UIView {
        let horizontalStack = UIStackView()
        horizontalStack.axis = .horizontal
        horizontalStack.spacing = CGFloat(SpacingXSmall)
        
        
        let image = resImage(name: resImageName)
        image.tintColor = contentColor
        horizontalStack.addSubview(image)
        
        
        let label = LabelSmall(text: text, color : contentColor)
        horizontalStack.addSubview(label)
        
        image.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.size.equalTo(8)
        }
        
        label.snp.makeConstraints { make in
            make.left.equalTo(image.snp.right).offset(SpacingXSmall)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        return horizontalStack
    }
    
}
