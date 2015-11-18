//
//  ImageObject.swift
//  iRouming
//
//  Created by Lope on 18/11/15.
//  Copyright © 2015 Lost Bytes. All rights reserved.
//

import UIKit

class ImageObject: FunnyObject {
	var thumbnail: UIImage?
	var image: UIImage?
	var urlImage: String
	var urlThumbnail: String
	var likes: UInt
	var dislikes: UInt
	
	override init(jsonData: [String : AnyObject]) {
		self.likes =  UInt(jsonData["likes"] as! String)!
		self.dislikes = UInt(jsonData["dislikes"] as! String)!
		self.urlImage = jsonData["url"] as! String
		self.urlThumbnail = jsonData["thumb"] as! String

		super.init(jsonData: jsonData)
		
		self.name = jsonData["nameReadable"] as! String
	}
}
