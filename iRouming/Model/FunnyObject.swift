//
//  FunnyObject.swift
//  iRouming
//
//  Created by Lope on 18/11/15.
//  Copyright © 2015 Lost Bytes. All rights reserved.
//

import UIKit
import Alamofire

let kCommentsLoadedNotification = "CommentsLoadedNotification"

class FunnyObject: NSObject {
	var name: String = ""
	var Id: UInt = 0
	var rating: UInt = 0
	var commentsCount: UInt = 0
	var loadingComments: Bool = false
	var lastCommentsLoaded: NSDate?
	var comments = [CommentObject]()
	
	init(jsonData: [String: AnyObject]) {
		self.name = jsonData["name"] as! String
		
		// jokes use "id" as Id key, other types use "object" key
		if let val = jsonData["id"] {
			if let Id = UInt(val as! String) {
				self.Id = Id
			}
		} else if let val = jsonData["object"] {
			if let Id = UInt(val as! String) {
				self.Id = Id
			}
		}
		
		if let val = jsonData["comments"] {
			if let commentsCount = UInt(val as! String) {
				self.commentsCount = commentsCount
			}
		}
		if let val = jsonData["rank"] {
			if let rating = UInt(val as! String) {
				self.rating = rating
			}
		}
	}
	
	func loadComments(force: Bool) {
		if self.loadingComments {
			return
		}
		
		if !force && self.lastCommentsLoaded != nil && self.lastCommentsLoaded!.timeIntervalSinceNow < 60 {
			return
		}
		
		self.loadingComments = true
		Alamofire.request(.GET, "http://www.rouming.cz/roumingXMLNew.php?action=comments&json=1&object=" + String(self.Id))
			.responseJSON { response in
				self.loadingComments = false
				
				switch response.result {
					case .Success(_):
						self.lastCommentsLoaded = NSDate()
						self.comments.removeAll()
						
						if let JSON = response.result.value as? [[String: AnyObject]] {
							for jsonObj in JSON {
								self.comments.append(CommentObject(jsonData: jsonObj))
							}
						}
						
						NSNotificationCenter.defaultCenter().postNotificationName(kCommentsLoadedNotification, object: self)
						
					break
					case .Failure(let error):
						print("Request failed with error: \(error)")
				}
		}
	}
}
