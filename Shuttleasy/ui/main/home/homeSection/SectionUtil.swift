//
//  SectionUtil.swift
//  Shuttleasy
//
//  Created by OguzhanMac on 28.03.2023.
//

import Foundation
import UIKit
import SnapKit

func createCardSection(
    title: String,
    subtitle : String,
    resImageName : String,
    contentColor : UIColor = onPrimaryContainer,
    subContentColor : UIColor = neutral40,
    titleTag : Int? = nil,
    subTitleTag: Int? = nil 
) -> UIView {
    let view = UIView()
    let image = resImageView(name: resImageName)
    view.addSubview(image)
    image.snp.makeConstraints { make in
        make.left.equalToSuperview()
        make.top.equalToSuperview()
    }
    
    image.tintColor = subContentColor

    let description = LabelSmall(text: subtitle, color : subContentColor)
    view.addSubview(description)
    if let tag = subTitleTag {
        description.tag = tag
    }
    description.snp.makeConstraints { make in
        make.left.greaterThanOrEqualTo(image.snp.right).offset(8)
        make.top.equalTo(image.snp.top)
        make.bottom.equalTo(image.snp.bottom)
    }

    let sectionTitle = TitleSM(text: title, color: contentColor)
    view.addSubview(sectionTitle)
    if let tag = titleTag {
        sectionTitle.tag = tag
    }
    // place below the image and align to left as image
    sectionTitle.snp.makeConstraints { make in
        make.left.equalToSuperview()
        make.right.lessThanOrEqualToSuperview()
        make.top.greaterThanOrEqualTo(image.snp.bottom).offset(6)
    }
    
    return view
}
