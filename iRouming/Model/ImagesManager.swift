//
//  ImagesManager.swift
//  iRouming
//
//  Created by Lope on 19/11/15.
//  Copyright © 2015 Lost Bytes. All rights reserved.
//

import UIKit
import Alamofire

let kImagesLoadedNotification = "ImagesLoadedNotification"

class ImagesManager: NSObject {
	var images = [ImageObject]()
	
	func loadImages() {
		Alamofire.request(.GET, "http://kecy.roumen.cz/roumingXMLNew.php?json=1")
			.responseJSON { response in
				if let JSON = response.result.value as? [[String: AnyObject]] {
					self.images.removeAll()
					for jsonObj in JSON {
						self.images.append(ImageObject(jsonData: jsonObj))
					}
				}
				
				NSNotificationCenter.defaultCenter().postNotificationName(kImagesLoadedNotification, object: nil)
		}
	}
}
