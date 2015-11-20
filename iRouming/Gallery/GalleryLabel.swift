//
//  GalleryLabel.swift
//  iRouming
//
//  Created by Lope on 19/11/15.
//  Copyright © 2015 Lost Bytes. All rights reserved.
//

import UIKit

class GalleryLabel: UILabel {

	func setTitle(text: String) {
		var fontSize: CGFloat = 16.0
		let oldWidth = self.frame.size.width
		let oldHeight = self.frame.size.height
		self.numberOfLines = 0
		self.text = text
		repeat {
			fontSize--
			self.font = UIFont.systemFontOfSize(fontSize)
			self.sizeToFit()
			self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, oldWidth, self.frame.size.height)
		} while (self.frame.size.height > oldHeight)
		
		self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, oldWidth, oldHeight)
	}

}
