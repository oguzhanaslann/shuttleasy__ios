//
//  Type.swift
//  Shuttleasy
//
//  Created by Oğuzhan Aslan on 13.11.2022.
//

import Foundation
import UIKit

func DisplayLarge(
    text : String,
    color : UIColor = .black,
    font : UIFont  = UIFont.poppinsMedium(size: 57) ?? UIFont.systemFont(ofSize: 57)
) -> UILabel {
    let label = UILabel()
    label.text = text
    label.textColor = color
    label.font = font
    return label
}

func DisplayMedium(
    text : String,
    color : UIColor = .black,
    font : UIFont  = UIFont.poppinsSemiBold(size: 45) ?? UIFont.systemFont(ofSize: 45)
) -> UILabel {
    let label = UILabel()
    label.text = text
    label.textColor = color
    label.font = font
    return label
}

func DisplaySmall(
    text : String,
    color : UIColor = .black,
    font : UIFont  = UIFont.poppinsMedium(size: 36) ?? UIFont.systemFont(ofSize: 36)
) -> UILabel {
    let label = UILabel()
    label.text = text
    label.textColor = color
    label.font = font
    return label
}

func HeadlineLarge(
    text : String,
    color : UIColor = .black,
    font : UIFont  = UIFont.poppinsSemiBold(size: 32) ?? UIFont.systemFont(ofSize: 32)
) -> UILabel {
    let label = UILabel()
    label.text = text
    label.textColor = color
    label.font = font
    return label
}

func HeadlineMedium(
    text : String,
    color : UIColor = .black,
    font : UIFont  = UIFont.poppinsSemiBold(size: 28) ?? UIFont.systemFont(ofSize: 28)
) -> UILabel {
    let label = UILabel()
    label.text = text
    label.textColor = color
    label.font = font
    return label
}

func HeadlineSmall(
    text : String,
    color : UIColor = .black,
    font : UIFont  = UIFont.poppinsSemiBold(size: 24) ?? UIFont.systemFont(ofSize: 24)
) -> UILabel {
    let label = UILabel()
    label.text = text
    label.textColor = color
    label.font = font
    return label
}



func TitleLarge(
    text : String,
    color : UIColor = .black,
    font : UIFont  = UIFont.poppinsSemiBold(size: 22) ?? UIFont.systemFont(ofSize: 22)
) -> UILabel {
    let label = UILabel()
    label.text = text
    label.textColor = color
    label.font = font
    return label
}



func TitleMedium(
    text : String,
    color : UIColor = .black,
    font : UIFont  = UIFont.poppinsSemiBold(size: 16) ?? UIFont.systemFont(ofSize: 16)
) -> UILabel {
    let label = UILabel()
    label.text = text
    label.textColor = color
    label.font = font
    return label
}

func TitleSmall(
    text : String,
    color : UIColor = .black,
    font : UIFont  = TitleSmallFont()
) -> UILabel {
    let label = UILabel()
    label.text = text
    label.textColor = color
    label.font = font
    return label
}

func TitleSmallFont()  -> UIFont {
    return UIFont.poppinsMedium(size: 14) ?? UIFont.systemFont(ofSize: 14)
}


func LabelLarge(
    text : String,
    color : UIColor = .black,
    font : UIFont  = UIFont.poppinsSemiBold(size: 16) ?? UIFont.systemFont(ofSize: 16)
) -> UILabel {
    let label = UILabel()
    label.text = text
    label.textColor = color
    label.font = font
    return label
}

func ButtonFont() -> UIFont {
    return UIFont.poppinsSemiBold(size: 16) ?? UIFont.systemFont(ofSize: 16)
}

func LabelMedium(
    text : String,
    color : UIColor = .black,
    font : UIFont  = UIFont.poppinsMedium(size: 14) ?? UIFont.systemFont(ofSize: 14)
) -> UILabel {
    let label = UILabel()
    label.text = text
    label.textColor = color
    label.font = font
    return label
}

func LabelSmall(
    text : String,
    color : UIColor = .black,
    font : UIFont  = UIFont.poppinsLight(size: 11) ?? UIFont.systemFont(ofSize: 11)
) -> UILabel {
    let label = UILabel()
    label.text = text
    label.textColor = color
    label.font = font
    return label
}


func BodyLarge(
    text : String,
    color : UIColor = .black,
    font : UIFont  = UIFont.poppinsRegular(size: 16) ?? UIFont.systemFont(ofSize: 16)
) -> UILabel {
    let label = UILabel()
    label.text = text
    label.textColor = color
    label.font = font
    return label
}

func BodyMedium(
    text : String,
    color : UIColor = .black,
    font : UIFont  = UIFont.poppinsRegular(size: 14) ?? UIFont.systemFont(ofSize: 14)
) -> UILabel {
    let label = UILabel()
    label.text = text
    label.textColor = color
    label.font = font
    return label
}

func BodySmall(
    text : String,
    color : UIColor = .black,
    font : UIFont  = BodySmallFont()
) -> UILabel {
    let label = UILabel()
    label.text = text
    label.textColor = color
    label.font = font
    return label
}

func BodySmallFont() -> UIFont {
    return UIFont.poppinsRegular(size: 12) ?? UIFont.systemFont(ofSize: 12)
}
