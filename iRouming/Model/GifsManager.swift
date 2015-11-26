//
//  GifsManager.swift
//  iRouming
//
//  Created by Lope on 19/11/15.
//  Copyright © 2015 Lost Bytes. All rights reserved.
//

import UIKit
import Alamofire

let kGifsLoadedNotification = "GifsLoadedNotification"

class GifsManager: NSObject {
	var gifs = [GifObject]()
	
	func loadGifs() {
		Alamofire.request(.GET, "http://kecy.roumen.cz/roumingXMLNew.php?action=gif&json=1")
			.responseJSON { response in
				if let JSON = response.result.value as? [[String: AnyObject]] {
					self.gifs.removeAll()
					for jsonObj in JSON {
						self.gifs.append(GifObject(jsonData: jsonObj))
					}
				}
				
				NSNotificationCenter.defaultCenter().postNotificationName(kGifsLoadedNotification, object: nil)
		}
	}
}
