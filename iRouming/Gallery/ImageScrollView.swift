//
//  ImageScrollView.swift
//  iRouming
//
//  Created by Lope on 19/11/15.
//  Copyright © 2015 Lost Bytes. All rights reserved.
//

import UIKit
import Alamofire

let kGalleryImageDoubleTapNotification = "GalleryImageDoubleTapNotification"

class ImageScrollView: UIScrollView, UIScrollViewDelegate {

	var imageView: UIImageView!
	var imageObject: ImageObject?
	var imageRequest: Request?
	
	func initialize() {
		self.imageView = UIImageView(frame: self.bounds)
		self.addSubview(self.imageView)
		
		self.imageView.contentMode = .ScaleAspectFit
		
		self.showsVerticalScrollIndicator = false
		self.showsHorizontalScrollIndicator = false
		self.bouncesZoom = true
		self.decelerationRate = UIScrollViewDecelerationRateFast
		self.delegate = self
		
		let doubleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: "handleDoubleTap")
		doubleTapGestureRecognizer.numberOfTapsRequired = 2
		self.addGestureRecognizer(doubleTapGestureRecognizer)
		
		let singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: "handleSingleTap")
		singleTapGestureRecognizer.numberOfTapsRequired = 1
		singleTapGestureRecognizer.requireGestureRecognizerToFail(doubleTapGestureRecognizer)
		self.addGestureRecognizer(singleTapGestureRecognizer)
	}
	
	func handleSingleTap() {
		NSNotificationCenter.defaultCenter().postNotificationName(kGalleryImageDoubleTapNotification, object: nil)
	}
	
	func handleDoubleTap() {
		if self.zoomScale == self.maximumZoomScale {
			self.zoomScale = self.minimumZoomScale
		} else {
			self.zoomScale = self.maximumZoomScale
		}
	}
	
	func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
		return self.imageView
	}
	
	func setMaxMinZoomScalesForCurrentBounds() {
		if self.imageView.image == nil {
			return
		}
		
		let boundsSize = self.bounds.size
		let imageSize = self.imageView.image!.size
		
		// calculate min/max zoomscale
		let xScale = boundsSize.width / imageSize.width    // the scale needed to perfectly fit the image width-wise
		let yScale = boundsSize.height / imageSize.height  // the scale needed to perfectly fit the image height-wise
		var minScale = min(xScale, yScale)                 // use minimum of these to allow the image to become fully visible
		
		// on high resolution screens we have double the pixel density, so we will be seeing every pixel if we limit the
		// maximum zoom scale to 0.5.
		let maxScale = 1.0 * UIScreen.mainScreen().scale
		
		// don't let minScale exceed maxScale. (If the image is smaller than the screen, we don't want to force it to be zoomed.)
		if minScale > maxScale {
			minScale = maxScale
		}
	
		self.maximumZoomScale = maxScale
		self.minimumZoomScale = minScale
	
		self.zoomScale = minScale
	}
	
	func pointToCenterAfterRotation() -> CGPoint {
		let boundsCenter = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds))
		return self.convertPoint(boundsCenter, toView: self.imageView)
	}
	
	// returns the zoom scale to attempt to restore after rotation.
	func scaleToRestoreAfterRotation() -> CGFloat {
		var contentScale = self.zoomScale
	
		// If we're at the minimum zoom scale, preserve that by returning 0, which will be converted to the minimum
		// allowable scale when the scale is restored.
		if contentScale <= self.minimumZoomScale + CGFloat(FLT_EPSILON) {
			contentScale = 0
		}
		
		return contentScale
	}
	
	func maximumContentOffset() -> CGPoint {
		return CGPointMake(self.contentSize.width - self.bounds.size.width, self.contentSize.height - self.bounds.size.height)
	}
	
	func minimumContentOffset() -> CGPoint {
		return CGPointZero
	}
	
	// Adjusts content offset and scale to try to preserve the old zoomscale and center.
	func restoreCenterPoint(center oldCenter: CGPoint, scale oldScale:CGFloat) {
		// Step 1: restore zoom scale, first making sure it is within the allowable range.
		self.zoomScale = min(self.maximumZoomScale, max(self.minimumZoomScale, oldScale))
		
		// Step 2: restore center point, first making sure it is within the allowable range.
		
		// 2a: convert our desired center point back to our own coordinate space
		let boundsCenter = self.convertPoint(oldCenter, fromView: self.imageView)
		// 2b: calculate the content offset that would yield that center point
		var offset = CGPointMake(boundsCenter.x - self.bounds.size.width / 2.0, boundsCenter.y - self.bounds.size.height / 2.0)
		// 2c: restore offset, adjusted to be within the allowable range
		let maxOffset = self.maximumContentOffset()
		let minOffset = self.minimumContentOffset()
		offset.x = max(minOffset.x, min(maxOffset.x, offset.x))
		offset.y = max(minOffset.y, min(maxOffset.y, offset.y))
		self.contentOffset = offset
	}
	
	func loadImage(imgObject: ImageObject) {
		if(self.imageView == nil) {
			self.initialize()
		}
	
		if self.imageObject == imgObject {
			return
		}
		
		self.imageObject = imgObject
		
		self.minimumZoomScale = 1
		self.maximumZoomScale = 1
		
		self.imageView.frame = self.frame

		self.imageView.image = nil
		if let request = self.imageRequest {
			request.cancel()
		}
		self.imageRequest = self.imageView.imageFromUrl(self.imageObject!.urlImage) { (image) -> Void in
			self.imageView.image = image
			self.imageLoaded()
			self.imageView.image = image
			self.imageRequest = nil
		}
	}
	
	func imageLoaded() {
		self.zoomScale = 1
		if let image = self.imageView.image {
			self.imageView.frame = CGRectMake((self.frame.size.width - image.size.width) / 2, (self.frame.size.height - image.size.height) / 2, image.size.width, image.size.height)
		}
		self.setMaxMinZoomScalesForCurrentBounds()
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
	
		let boundsSize = self.bounds.size
		var frameToCenter = self.imageView.frame
		
		//center horizontaly
		if frameToCenter.size.width < boundsSize.width {
			frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2
		} else {
			frameToCenter.origin.x = 0
		}
		
		//center verticaly
		if frameToCenter.size.height < boundsSize.height {
			frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2
		} else {
			frameToCenter.origin.y = 0
		}
		
		self.imageView.frame = frameToCenter
	}

}
