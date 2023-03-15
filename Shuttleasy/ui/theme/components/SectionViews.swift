//
//  SectionViews.swift
//  Shuttleasy
//
//  Created by OguzhanMac on 23.02.2023.
//

import Foundation
import UIKit
import SnapKit

func sectionHeader(
    title : String,
    contentColor : UIColor = onBackgroundColor,
    textTag: Int? = nil
) -> UIView {
    let view = UIView()
    let label = LabelLarge(text: title, color : contentColor)
    view.addSubview(label)
    label.snp.makeConstraints { make in
        make.left.equalToSuperview()
        make.top.equalToSuperview()
    }
    
    if let tag = textTag {
        label.tag = tag 
    }
 
    let line = lineView(color : contentColor)
    view.addSubview(line)
    line.snp.makeConstraints { make in
        make.left.equalToSuperview()
        make.right.equalToSuperview()
        make.top.greaterThanOrEqualTo(label.snp.bottom).offset(8)
        make.height.equalTo(1)
    }
    return view
}

private func lineView(color : UIColor) -> UIView {
    let view = UIView()
    view.backgroundColor = color
    return view
}

func sectionRowView(
    resImageName : String,
    value : String,
    labelTag: Int? = nil,
    contentColor : UIColor = onBackgroundColor
) -> UIView {
    let view = UIView()
    let image = resImageView(name: resImageName)
    image.tintColor = contentColor
    view.addSubview(image)
    image.snp.makeConstraints { make in
        make.left.equalToSuperview()
        make.top.equalToSuperview()
    }

    let label = BodyMedium(text: value, color : contentColor)
    if let tag = labelTag {
        label.tag = tag
    }
    view.addSubview(label)
    label.snp.makeConstraints { make in
        make.right.equalTo(view.snp.right)
        
    }
    return view
}

func sectionRow(
    title : String,
    value : String,
    contentColor : UIColor = onBackgroundColor
) -> UIView {
    let view = UIView()
    let label = BodyMedium(text: title, color : contentColor)
    view.addSubview(label)
    label.snp.makeConstraints { make in
        make.left.equalToSuperview()
        make.top.equalToSuperview()
    }

    let valueLabel = BodyMedium(text: value,color: contentColor)
    view.addSubview(valueLabel)
    valueLabel.snp.makeConstraints { make in
        make.right.equalToSuperview()
        make.top.equalToSuperview()
    }
    return view
}


func sectionRowIconLabelView(
    resImageName : String,
    description : String,
    contentColor : UIColor = onBackgroundColor
) -> UIView {
    let view = UIView()
    let image = resImageView(name: resImageName)
    view.addSubview(image)
    image.snp.makeConstraints { make in
        make.left.equalToSuperview()
        make.top.equalToSuperview()
    }
    
    image.tintColor = contentColor

    let description = LabelMedium(text: description, color : contentColor)
    view.addSubview(description)
    description.snp.makeConstraints { make in
        make.left.greaterThanOrEqualTo(image.snp.right).offset(8)
        make.top.equalTo(image.snp.top)
        make.bottom.equalTo(image.snp.bottom)
    }
    
    let arrow = systemImage(systemName: "chevron.right", tint: contentColor)
    view.addSubview(arrow)
    arrow.snp.makeConstraints { make in
        make.right.equalToSuperview()
        make.centerY.equalToSuperview()
    }

    return view
}

func sectionWithEnterIcon(
    title : String
) -> UIView {
    return sectionEndIcon(title: title, iconView: systemImage(systemName: "chevron.right", tint: onBackgroundColor))
}

func sectionWithSwitchRow(
    switchTag : Int,
    title : String,
    titleColor : UIColor = onBackgroundColor
) -> UIView{
    let view = UIView()
    let label = LabelMedium(text: title, color: titleColor)
    view.addSubview(label)
    label.snp.makeConstraints { make in
        make.left.equalToSuperview()
        make.top.equalToSuperview()
    }

    let switchView = UISwitch()
    switchView.tintColor = onPrimaryColor
    switchView.onTintColor = primaryColor
    switchView.tag = switchTag

    view.addSubview(switchView)
    switchView.snp.makeConstraints { make in
        make.right.equalToSuperview()
        make.centerY.equalToSuperview()
    }

    return view
}

func sectionEndIcon(
    title : String,
    iconView : UIImageView,
    contentColor : UIColor = onBackgroundColor
) -> UIView {
    let view = UIView()
    let label = LabelMedium(text: title, color: contentColor)
    view.addSubview(label)
    label.snp.makeConstraints { make in
        make.left.equalToSuperview()
        make.top.equalToSuperview()
    }

    let arrow = iconView
    iconView.tintColor = contentColor
    view.addSubview(arrow)
    arrow.snp.makeConstraints { make in
        make.right.equalToSuperview()
        make.centerY.equalToSuperview()
    }
    
    iconView.isUserInteractionEnabled = true

    return view
}
