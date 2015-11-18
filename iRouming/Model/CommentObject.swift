//
//  CommentObject.swift
//  iRouming
//
//  Created by Lope on 18/11/15.
//  Copyright © 2015 Lost Bytes. All rights reserved.
//

import UIKit

class CommentObject: NSObject {
	var nick: String = ""
	var message: String = ""
	var date: NSDate = NSDate()
	var registered: Bool = false
	
	init(jsonData: [String: AnyObject]) {
		self.nick = jsonData["nick"] as! String
		self.message = jsonData["message"] as! String
		self.date = NSDate(timeIntervalSince1970: Double(jsonData["timestamp"] as! String)!)
		self.registered = Int(jsonData["registered"] as! String) == 1
	}
}
