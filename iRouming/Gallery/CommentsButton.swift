//
//  CommentsButton.swift
//  iRouming
//
//  Created by Lope on 19/11/15.
//  Copyright © 2015 Lost Bytes. All rights reserved.
//

import UIKit

class CommentsButton: UIButton {

	var imageViewBubble: UIImageView!
	var labelCount: UILabel!
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		
		self.imageViewBubble = UIImageView(image: UIImage(named: "comments_bubble"))
		self.addSubview(self.imageViewBubble)
		
		self.labelCount = UILabel(frame: CGRectMake(18, 0, 15, 10))
		self.labelCount.text = "0"
		self.labelCount.textColor = UIColor.whiteColor()
		self.labelCount.font = UIFont(name: "Titillium-Semibold", size:8)
		self.addSubview(self.labelCount)
	}
	
	func setCommentCount(count: Int) {
		if count == -1 {
			self.labelCount.text = "-"
		} else {
			self.labelCount.text = String(count)
		}
		
		self.updateFrames()
	}
	
	func updateFrames() {
		self.labelCount.frame = CGRectMake(30, 7, 20, 10)
		self.labelCount.sizeToFit()
	
		self.imageViewBubble.frame = CGRectMake(28, 5, self.labelCount.frame.size.width + 4, 10)
	}


}
