//
//  UIImageView+Alamofire.swift
//  iRouming
//
//  Created by Lope on 19/11/15.
//  Copyright © 2015 Lost Bytes. All rights reserved.
//

import UIKit
import Alamofire

extension UIImageView {
	public func imageFromUrl(urlString: String) -> Request {
		return Alamofire.request(.GET, urlString).response { (request, response, data, error) in
			self.image = UIImage(data: data!, scale:1)
		}
	}
	
	public func imageFromUrl(urlString: String, result: (image: UIImage?) -> Void) -> Request {
		return Alamofire.request(.GET, urlString).response { (request, response, data, error) in
			result(image: UIImage(data: data!, scale:1))
		}
	}
}