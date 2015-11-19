//
//  ImagesCell.swift
//  iRouming
//
//  Created by Lope on 19/11/15.
//  Copyright © 2015 Lost Bytes. All rights reserved.
//

import UIKit

class ImagesCell: UITableViewCell {

	@IBOutlet var thumbnailView: UIImageView!
	@IBOutlet var labelName: UILabel!
	@IBOutlet var labelLikes: UILabel!
	@IBOutlet var labelComments: UILabel!

	func setImageObject(imageObj: ImageObject) {
		self.labelName.text = imageObj.name
		self.thumbnailView.image = nil
		self.thumbnailView.imageFromUrl(imageObj.urlThumbnail)
		
		let likesStr = String(imageObj.likes) + " / " + String(imageObj.dislikes)
		
		let attributedString = NSMutableAttributedString(string: likesStr, attributes: [NSFontAttributeName: UIFont(name: "Titillium-Light", size: 12)!, NSForegroundColorAttributeName: UIColor.whiteColor()])
		
		let separatorPos = likesStr.rangeOfString("/")?.startIndex
		let separatorOffset = likesStr.startIndex.distanceTo(separatorPos!)
		attributedString.setAttributes([NSForegroundColorAttributeName: UIColor(red: 55.0 / 255.0, green: 232.0 / 255.0, blue: 14.0 / 255.0, alpha: 1)], range:  NSMakeRange(0, separatorOffset))
		attributedString.setAttributes([NSForegroundColorAttributeName: UIColor(red: 243.0 / 255.0, green: 1.0 / 255.0, blue: 1.0 / 255.0, alpha: 1)], range:  NSMakeRange(separatorOffset + 1, separatorPos!.distanceTo(likesStr.endIndex) - 1))

		self.labelLikes.attributedText = attributedString
		self.labelComments.text = String(imageObj.commentsCount)
	}

}
