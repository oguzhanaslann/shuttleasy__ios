//
//  Checkbox.swift
//  Shuttleasy
//
//  Created by Oğuzhan Aslan on 20.11.2022.
//

import Foundation
import UIKit
import SnapKit

class Checkbox: UIButton {
    
    private (set)  var isChecked: Bool = false
        

    private lazy var checkedImage : UIImageView = {
    // rectangle filled sf symbol    
        let image = getImage()
        let imageView = UIImageView(image: image )     
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder : NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        addSubview(checkedImage)
        // center 
        checkedImage.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

    // toggle 
    @objc func toggle() {
        isChecked = !isChecked
        checkedImage.image = getImage()
    }
    
    func getImage() -> UIImage? {
        return isChecked ? UIImage(systemName: "checkmark.square.fill") : UIImage(systemName: "square")
    }
}
