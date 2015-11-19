//
//  ForumManager.swift
//  iRouming
//
//  Created by Lope on 19/11/15.
//  Copyright © 2015 Lost Bytes. All rights reserved.
//

import UIKit
import Alamofire

let kForumThreadLoadedNotification = "ForumThreadLoadedNotification"
let kForumThreadListLoadedNotification = "ForumThreadListLoadedNotification"

class ForumManager: NSObject {
	var currentThreadRequest: Alamofire.Request?
	var loadingThreads = false
	var loadingForum = false
	
	func loadForum() {
		if let req = self.currentThreadRequest  {
			req.cancel()
		}
		
		self.loadingForum = true
		
		self.currentThreadRequest = Alamofire.request(.GET, "http://www.rouming.cz/roumingXML.php?action=forum&json=1")
			.responseJSON { response in
				self.loadingForum = false
				
				switch response.result {
				case .Success:
					var result = [ForumPostObject]()
					
					if let JSON = response.result.value as? [[String: AnyObject]] {
						for jsonObj in JSON {
							result.append(ForumPostObject(jsonData: jsonObj))
						}
					}
					
					NSNotificationCenter.defaultCenter().postNotificationName(kForumThreadLoadedNotification, object: nil, userInfo: ["threadId": 0, "posts": result])
				case .Failure( _):
					UIAlertView(title: "Chyba!", message: "Nepodařilo se nahrát data ze serveru, zkuste to prosím později.", delegate: nil, cancelButtonTitle: "OK").show()
					NSNotificationCenter.defaultCenter().postNotificationName(kForumThreadLoadedNotification, object: nil, userInfo: ["threadId": 0])
				}
		}
	}
	
	func loadThreadList() {
		if self.loadingThreads {
			return
		}
	
		self.loadingThreads = true
		
		Alamofire.request(.GET, "http://www.rouming.cz/roumingXML.php?json=1&action=forumThreads")
			.responseJSON { response in
				self.loadingThreads = false
				
				switch response.result {
				case .Success:
					var result = [ForumThreadObject]()
					
					if let JSON = response.result.value as? [[String: AnyObject]] {
						for jsonObj in JSON {
							result.append(ForumThreadObject(jsonData: jsonObj))
						}
					}
					
					NSNotificationCenter.defaultCenter().postNotificationName(kForumThreadListLoadedNotification, object: nil, userInfo: ["threads": result])
				case .Failure( _):
					NSNotificationCenter.defaultCenter().postNotificationName(kForumThreadListLoadedNotification, object: nil)
				}
				
		}
	}
	
	func loadThread(threadId: UInt) {
		if let req = self.currentThreadRequest {
			req.cancel()
		}
	
		self.loadingForum = true
		
		self.currentThreadRequest = Alamofire.request(.GET, "http://www.rouming.cz/roumingXML.php?json=1&action=forum&thread=" + String(threadId))
			.responseJSON { response in
				self.loadingForum = false
				
				switch response.result {
				case .Success:
					var result = [ForumPostObject]()
					
					if let JSON = response.result.value as? [[String: AnyObject]] {
						for jsonObj in JSON {
							result.append(ForumPostObject(jsonData: jsonObj))
						}
					}
					
					NSNotificationCenter.defaultCenter().postNotificationName(kForumThreadLoadedNotification, object: nil, userInfo: ["threadId": threadId, "posts": result])
				case .Failure( _):
					UIAlertView(title: "Chyba!", message: "Nepodařilo se nahrát data ze serveru, zkuste to prosím později.", delegate: nil, cancelButtonTitle: "OK").show()
					NSNotificationCenter.defaultCenter().postNotificationName(kForumThreadLoadedNotification, object: nil, userInfo: ["threadId": threadId])
				}
		}
	}
}
