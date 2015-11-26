//
//  GifCell.swift
//  iRouming
//
//  Created by Lope on 19/11/15.
//  Copyright © 2015 Lost Bytes. All rights reserved.
//

import UIKit
import Alamofire

class GifCell: UICollectionViewCell {

	@IBOutlet var animView: FLAnimatedImageView!
	@IBOutlet var activityIndicator: UIActivityIndicatorView!
	
	var gif: GifObject? = nil
	static var operationQueue: NSOperationQueue?
	
	func setGifObject(gifObject: GifObject) {
		if self.gif != nil && self.gif!.Id == gifObject.Id {
			return
		}
		
		self.gif = gifObject
		
		if GifCell.operationQueue == nil {
			GifCell.operationQueue = NSOperationQueue()
			GifCell.operationQueue!.maxConcurrentOperationCount = 3
		}
		
		animView.animatedImage = nil
		activityIndicator.startAnimating()
		
		if let url = NSURL(string: gifObject.url) {
			let request = NSURLRequest(URL: url)
			NSURLConnection.sendAsynchronousRequest(request, queue: GifCell.operationQueue!, completionHandler: { (response, data, error) -> Void in
				if ((error) != nil) {
					NSLog("Download Error:%@", error!.description)
				}
				if ((data) != nil) {
					if self.gif!.Id == gifObject.Id {
						self.createGifImage(data!)
					}
				}
			})
		}
	}
	
	func createGifImage(gifData: NSData) {
		let img = FLAnimatedImage(animatedGIFData: gifData)
		dispatch_async(dispatch_get_main_queue(),{
			
			self.animView.animatedImage = img
			self.activityIndicator.stopAnimating()
			
		})
	}

}
