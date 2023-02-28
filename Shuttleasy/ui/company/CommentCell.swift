//
//  CommentCell.swift
//  Shuttleasy
//
//  Created by OguzhanMac on 24.02.2023.
//

import Foundation
import UIKit

class CommentCell: UITableViewCell {
    public static let identifier = "CommentCell"

    let commenterName = LabelLarge(text: "John doe", color: onSurfaceColor)
    let comment = BodyMedium(text : "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.", color : onSurfaceColor)
    
    let commentSendDate = LabelSmall(text: "01/01/2020", color: onSurfaceVariant)

    let commenterProfilePhoto =  UIImageView(image : UIImage(named: "shuttle_placeholder"))
        
    let commentCard = UIView()

    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(commentCard)
        initCardView()
        commentCard.addSubview(commenterProfilePhoto)
        commentCard.addSubview(commenterName)
        commentCard.addSubview(comment)
        commentCard.addSubview(commentSendDate)
        comment.breakLineFromEndIfNeeded()
        setConstraints()
    }
    
    private func initCardView() {
        commentCard.backgroundColor = surfaceVariant
        commentCard.layer.cornerRadius = 16
        commentCard.layer.masksToBounds = true
    }
    
    private func setConstraints() {
        commentCard.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(SpacingMedium)
            make.right.equalToSuperview().offset(-SpacingMedium)
            make.top.equalToSuperview().offset(SpacingMedium)
            make.bottom.equalToSuperview().offset(-SpacingMedium)
            make.height.equalTo(156)
        }

        commenterProfilePhoto.contentMode = .scaleToFill
        commenterProfilePhoto.snp.makeConstraints { make in
            make.left.top.equalToSuperview().offset(SpacingMedium)
            let dimensions = 72
            make.width.equalTo(dimensions)
            make.height.equalTo(dimensions)
            commenterProfilePhoto.layer.cornerRadius = CGFloat((dimensions / 2))
            commenterProfilePhoto.layer.masksToBounds = true
        }
        
        
        commenterName.snp.makeConstraints { make in
            make.left.equalTo(commenterProfilePhoto.snp.right).offset(SpacingSmall)
            make.right.lessThanOrEqualToSuperview().offset(SpacingMedium)
            make.width.greaterThanOrEqualTo(36)
            make.height.greaterThanOrEqualTo(24)
            make.top.equalToSuperview().offset(SpacingMedium)
        }
        
        
        comment.snp.makeConstraints { make in
            make.top.greaterThanOrEqualTo(commenterName.snp.bottom).offset(SpacingXSmall)
            make.left.equalTo(commenterProfilePhoto.snp.right).offset(SpacingSmall)
            make.right.equalToSuperview().offset(SpacingMedium)
        }
        
        
        commentSendDate.snp.makeConstraints { make in
            make.top.greaterThanOrEqualTo(commenterProfilePhoto.snp.bottom).offset(SpacingXSmall)
            make.left.equalTo(commenterProfilePhoto.snp.left)
            make.right.equalTo(commenterProfilePhoto.snp.right)
            commentSendDate.textAlignment = .center
        }
    }
}
