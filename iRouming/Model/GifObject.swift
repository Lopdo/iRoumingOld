//
//  GifObject.swift
//  iRouming
//
//  Created by Lope on 18/11/15.
//  Copyright © 2015 Lost Bytes. All rights reserved.
//

import UIKit

class GifObject: FunnyObject {
	var url: String
	
	override init(jsonData: [String : AnyObject]) {
		self.url = jsonData["url"] as! String
		
		super.init(jsonData: jsonData)
	}
}
