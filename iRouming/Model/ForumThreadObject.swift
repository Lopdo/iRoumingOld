//
//  ForumThreadObject.swift
//  iRouming
//
//  Created by Lope on 18/11/15.
//  Copyright © 2015 Lost Bytes. All rights reserved.
//

import UIKit

class ForumThreadObject: NSObject {
	var title: String
	var threadId: UInt
	var postsCount: UInt
	
	init(jsonData: [String: AnyObject]) {
		self.title = jsonData["description"] as! String
		self.threadId = UInt(jsonData["thread"] as! String)!
		self.postsCount = UInt(jsonData["posts"] as! String)!
	}
}
