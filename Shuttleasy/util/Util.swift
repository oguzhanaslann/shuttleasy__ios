//
//  Util.swift
//  Shuttleasy
//
//  Created by Oğuzhan Aslan on 13.11.2022.
//

import Foundation
import UIKit

func systemImage(
    systemName : String,
    clipToBounds : Bool? = nil,
    borderColor: CGColor? = nil,
    borderWidth : CGFloat? = nil,
    tint : UIColor? = nil
)  -> UIImageView {
    let image = UIImage(systemName: systemName)
    let imageView = UIImageView(image: image)
    
    if clipToBounds !=  nil {
        imageView.clipsToBounds = clipToBounds!
    }
    
    if borderColor !=  nil {
        imageView.layer.borderColor = borderColor!
    }
    
    if borderWidth !=  nil {
        imageView.layer.borderWidth = borderWidth!
    }
    
    if tint != nil {
        imageView.tintColor = tint!
    }
    
    return imageView
}

func resImage (
    name : String,
    clipToBounds : Bool? = nil,
    borderColor: CGColor? = nil,
    borderWidth : CGFloat? = nil
)  -> UIImageView {
    let image = UIImage(named: name)
    let imageView = UIImageView(image: image)
    
    if clipToBounds !=  nil {
        imageView.clipsToBounds = clipToBounds!
    }
    
    if borderColor !=  nil {
        imageView.layer.borderColor = borderColor!
    }
    
    if borderWidth !=  nil {
        imageView.layer.borderWidth = borderWidth!
    }
    
    return imageView
}
