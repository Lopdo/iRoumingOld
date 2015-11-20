//
//  JokesManager.swift
//  iRouming
//
//  Created by Lope on 19/11/15.
//  Copyright © 2015 Lost Bytes. All rights reserved.
//

import UIKit
import Alamofire

let kJokesLoadedNotification = "JokesLoadedNotification"

class JokesManager: NSObject {
	var jokes = [JokeObject]()
	
	var loadingJokePage: Int = 0
	var currentJokePage: Int = 0
	
	func makeJokesCall() {
		Alamofire.request(.GET, "http://kecy.roumen.cz/roumingXMLNew.php?action=jokes&json=1&page=%i" + String(self.currentJokePage))
			.responseJSON { response in
				if let JSON = response.result.value as? [[String: AnyObject]] {
					if self.currentJokePage == 0 {
						self.jokes.removeAll()
					}
					
					for jsonObj in JSON {
						self.jokes.append(JokeObject(jsonData: jsonObj))
					}
				}
				
				NSNotificationCenter.defaultCenter().postNotificationName(kJokesLoadedNotification, object: nil)
				
				self.loadingJokePage = -1
		}
	}
	
	func loadJokes() {
		self.loadingJokePage = 0
		self.currentJokePage = 0
	
		self.makeJokesCall()
	}
	
	func loadNextPage() {
		if(self.loadingJokePage != -1) {
			return
		}
	
		self.currentJokePage++
		self.loadingJokePage = self.currentJokePage
	
		self.makeJokesCall()
	}
}
