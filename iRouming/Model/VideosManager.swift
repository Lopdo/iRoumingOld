//
//  VideosManager.swift
//  iRouming
//
//  Created by Lope on 19/11/15.
//  Copyright © 2015 Lost Bytes. All rights reserved.
//

import UIKit
import Alamofire

let kVideosLoadedNotification = "VideosLoadedNotification"

class VideosManager: NSObject {
	var videos = [VideoObject]()
	
	func loadVideos() {
		Alamofire.request(.GET, "http://kecy.roumen.cz/roumingXMLNew.php?action=videos&json=1")
			.responseJSON { response in
				if let JSON = response.result.value as? [[String: AnyObject]] {
					self.videos.removeAll()
					for jsonObj in JSON {
						self.videos.append(VideoObject(jsonData: jsonObj))
					}
				}
				
				NSNotificationCenter.defaultCenter().postNotificationName(kVideosLoadedNotification, object: nil)
		}
	}
}
