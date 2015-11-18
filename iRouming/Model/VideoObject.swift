//
//  VideoObject.swift
//  iRouming
//
//  Created by Lope on 18/11/15.
//  Copyright © 2015 Lost Bytes. All rights reserved.
//

import UIKit

class VideoObject: FunnyObject {
	var youtubeId: String
	
	override init(jsonData: [String : AnyObject]) {
		let url = jsonData["url"] as! String
		self.youtubeId = url.substringFromIndex(url.rangeOfString("=")!.startIndex.advancedBy(1))
		
		super.init(jsonData: jsonData)
	}
}
