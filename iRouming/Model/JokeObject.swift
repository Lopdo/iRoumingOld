//
//  JokeObject.swift
//  iRouming
//
//  Created by Lope on 18/11/15.
//  Copyright © 2015 Lost Bytes. All rights reserved.
//

import UIKit

class JokeObject: FunnyObject {
	var text: String
	var category: String
	
	override init(jsonData: [String : AnyObject]) {
		self.text = jsonData["text"] as! String
		self.category = jsonData["typeName"] as! String

		super.init(jsonData: jsonData)
	}
}
