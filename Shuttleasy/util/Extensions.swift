//
//  Extensions.swift
//  Shuttleasy
//
//  Created by Oğuzhan Aslan on 13.11.2022.
//

import Foundation
import UIKit

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
            .make(in: self.view, message: message, duration: duration, styleBuilder: {
                var style = SnackBarStyle()
                style.textColor = onPrimaryColor
                style.background = primaryColor
                style.font = BodySmallFont()
                return style
            })
        .show()
    }
    
}
