//
//  FontUtil.swift
//  Shuttleasy
//
//  Created by Oğuzhan Aslan on 12.11.2022.
//

import Foundation
import UIKit

extension UIFont {
    static func poppinsBlack(size: CGFloat) ->  UIFont? {
        return UIFont(name: "Poppins-Black", size: size)
    }

    static func poppinsBold(size: CGFloat) ->  UIFont? {
        return UIFont(name: "Poppins-Bold", size: size)
    }
    
    static func poppinsSemiBold(size: CGFloat) ->  UIFont? {
        return UIFont(name: "Poppins-SemiBold", size: size)
    }
    
    static func poppinsMedium(size: CGFloat) ->  UIFont? {
        return UIFont(name: "Poppins-Medium", size: size)
    }
    
    static func poppinsRegular(size: CGFloat) ->  UIFont? {
        return UIFont(name: "Poppins-Regular", size: size)
    }
    
    static func poppinsLight(size :CGFloat) -> UIFont? {
        return UIFont(name: "Poppins-Light", size: size)
    }
}
