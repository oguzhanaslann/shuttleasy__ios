//
//  Extensions.swift
//  Shuttleasy
//
//  Created by Oğuzhan Aslan on 13.11.2022.
//

import Foundation
import UIKit
import Kingfisher
import Combine

extension UIScrollView {
    func scrollTo(horizontalPage : Int = 0, verticalPage: Int = 0, animated : Bool = true) {
        var frame = self.frame
        frame.origin.x = frame.size.width * CGFloat(horizontalPage)
        frame.origin.y = frame.size.width * CGFloat(verticalPage)
        self.scrollRectToVisible(frame, animated: animated)
    }
}

extension UILabel {
    func breakLineFromEndIfNeeded() {
        self.adjustsFontSizeToFitWidth = false
        self.numberOfLines = 0
        self.lineBreakMode = .byTruncatingTail
    }
    
    func setLetterSpacing(text: String, withKerning kerning: CGFloat) {
        let attributedString = NSMutableAttributedString(string: text)
        // The value parameter defines your spacing amount, and range is
        // the range of characters in your string the spacing will apply to.
        // Here we want it to apply to the whole string so we take it from 0 to text.count.
        attributedString.addAttribute(NSAttributedString.Key.kern, value: kerning, range: NSMakeRange(0, text.count))
        attributedText = attributedString
    }
}


extension UIView {
    func hide() {
        self.isHidden = true
    }
    
    func present() {
        self.isHidden = false
    }
    
}

extension UIAlertController {
    func showOn(_ controller: UIViewController, isAnimated : Bool , completion: (() -> Void)? = nil) {
        controller.present(self, animated: isAnimated, completion: completion)
    }
}

extension Bool {
    func not()  -> Bool {
        return !self
    }
}

extension String {
    func localize(_ key : String? = nil) -> String {
      return NSLocalizedString( key ?? self , comment: "")
    }
    
    func withPrefix(prefix: String, checkExistence ofPrefix : Bool) -> String {
        if ofPrefix && self.hasPrefix(prefix).not() {
            return prefix + self
        } else {
            return self
        }
    }
}

extension UIControl {
    func setOnClickListener(for controlEvents: UIControl.Event = .primaryActionTriggered, action: @escaping () -> ()) {
        let sleeve = ClosureSleeve(attachTo: self, closure: action)
        addTarget(sleeve, action: #selector(ClosureSleeve.invoke), for: controlEvents)
    }
}

extension NSMutableAttributedString {
    
    func span(
        _ value:String,
        font :UIFont,
        foregroundColor : UIColor
    ) -> NSMutableAttributedString {
        
        let attributes:[NSAttributedString.Key : Any] = [
            .font : font,
            .foregroundColor : foregroundColor
        ]
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
}


extension UIViewController {
    func showErrorSnackbar(message : String, duration : SnackBar.Duration = .lengthShort ) {
        SnackBar
            .make(in: self.view, message: message, duration: duration, styleBuilder: {
                var style = SnackBarStyle()
                style.textColor = errorColor
                style.background = errorContainer
                style.font = BodySmallFont()
                return style
            })
        .show()
    }
    
    func showInformationSnackbar(message : String, duration : SnackBar.Duration = .lengthShort ) {
        SnackBar
            .make(
                in: self.view,
                message: message,
                duration: duration,
                styleBuilder: {
                    var style = SnackBarStyle()
                    style.textColor = onPrimaryColor
                    style.background = primaryColor
                    style.font = BodySmallFont()
                    return style
                }
            )
        .show()
    }
    
    
    func showAlertDialog(
        title: String,
        message : String,
        actions: [UIAlertAction]
    ) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )

        
        actions.forEach { action in
            alert.addAction(action)
        }
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func handleCompletion(_ completion :  Subscribers.Completion<Error>) {
        switch completion {
            case .failure(let error):
                self.showErrorSnackbar(message: error.localizedDescription)
            case .finished:
                break
            }
    }
    
    func handleCompletion(_ completion :  Subscribers.Completion<Never>) {
        switch completion {
            case .failure(let error):
                self.showErrorSnackbar(message: error.localizedDescription)
            case .finished:
                break
            }
    }
}

extension UIImageView {
    func load(url: String) {
        let url = URL(string: url)
        self.kf.setImage(with: url)
    }
}


enum PhoneRegionFormatError: Error {
    case invalidPhoneNumber(reason: String)
}

extension String {
    func withoutRegionCode(checkFirst: Bool = false) throws -> String {
        if checkFirst {
            let normalizedPhone: String
            if starts(with: "+") {
                normalizedPhone = String(dropFirst(3))
            } else if starts(with: "0") {
                normalizedPhone = String(dropFirst(1))
            } else {
                normalizedPhone = self
            }

            if normalizedPhone.count == 10 {
                return normalizedPhone
            } else {
                let errorMessage: String
                if normalizedPhone.count < 10 {
                    errorMessage = "Phone number is too short"
                } else {
                    errorMessage = "Phone number is too long"
                }
                throw PhoneRegionFormatError.invalidPhoneNumber(reason: errorMessage)
            }

        } else {
            return String(dropFirst(3))
        }
    }

    func withoutRegionCodeOrEmpty(checkFirst : Bool = false) -> String {
        do {
            return try withoutRegionCode(checkFirst: checkFirst)
        } catch {
            return ""
        }
    }
}
extension UIView {
    func transparentBackground() {
        self.backgroundColor = UIColor.clear
    }
}


extension UITableView {
    func defaultSetup() {
        self.rowHeight = UITableView.automaticDimension
        self.separatorStyle = .none
        self.showsVerticalScrollIndicator = false
    }
}


extension UIView {
    func addoverlay(color: UIColor = .black,alpha : CGFloat = 0.6) {
        let overlay = UIView()
        overlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        overlay.frame = bounds
        overlay.backgroundColor = color
        overlay.alpha = alpha
        addSubview(overlay)
    }
}

extension UICollectionView {
    func defaultSetup() {
        self.showsHorizontalScrollIndicator = false
        self.isPagingEnabled = true
        self.isScrollEnabled = true
        self.backgroundColor = .clear
    }
}

// String? -  Extension : toDoubleOrZero , safe cast to Double
extension String {
    func toDoubleOrZero() -> Double {
        return Double(self) ?? 0
    }
}
