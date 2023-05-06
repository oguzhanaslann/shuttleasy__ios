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

func resImageView (
    name : String,
    clipToBounds : Bool? = nil,
    borderColor: CGColor? = nil,
    borderWidth : CGFloat? = nil,
    tint : UIColor? = nil
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
    
    if tint != nil {
        imageView.tintColor = tint!
    }
    
    
    return imageView
}

func resImage(
    name : String
) -> UIImage? {
    let image = UIImage(named: name)
    return image
}


func isValidEmail(_ email : String) -> Bool{
    let emailPattern = #"^\S+@\S+\.\S+$"#
    
    var result = email.range(
        of: emailPattern,
        options: .regularExpression
    )

    let validEmail = (result != nil)
    return validEmail
}

func isValidPassword(_ password : String) -> Bool{
    // let passwordPattern = #"^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$"#
    
    // var result = password.range(
        // of: passwordPattern,
        // options: .regularExpression
    // )

    // let validPassword = (result != nil)
    return password.isEmpty.not()
}


func generateQRCode(from string: String) -> UIImage? {
    let data = string.data(using: String.Encoding.ascii)
    if let QRFilter = CIFilter(name: "CIQRCodeGenerator") {
        QRFilter.setValue(data, forKey: "inputMessage")
        guard let QRImage = QRFilter.outputImage else {return nil}
        return UIImage(ciImage: QRImage)
    }
    return nil
}


func isValidPhone(_ phone: String) -> Bool {
    
    if phone.count != 13 {
        return false
    }
    
    let phoneRegex = "^\\+[0-9]{10,13}$"
    let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
    return phoneTest.evaluate(with: phone)
}


func setNavBackButton(
    navigationItem: UINavigationItem,
    target: Any?,
    action: Selector?,
    image : UIImage? = UIImage(systemName: "arrow.left")
) {
    let dismissButton = UIBarButtonItem(
        image: image,
        style: .plain,
        target: target,
        action: action
    )
    navigationItem.leftBarButtonItem = dismissButton
}
