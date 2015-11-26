//
//  ForumThreadCell.swift
//  iRouming
//
//  Created by Lope on 19/11/15.
//  Copyright © 2015 Lost Bytes. All rights reserved.
//

import UIKit

class ForumThreadCell: UITableViewCell {

	@IBOutlet var labelTitle: UILabel!
	@IBOutlet var labelCount: UILabel!
	
	var thread: ForumThreadObject?
	
	func setThreadObject(threadObj: ForumThreadObject) {
		self.labelTitle.text = threadObj.title
		self.labelCount.text = String(threadObj.postsCount)
	}
}
