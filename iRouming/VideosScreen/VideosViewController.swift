//
//  VideosViewController.swift
//  iRouming
//
//  Created by Lope on 19/11/15.
//  Copyright © 2015 Lost Bytes. All rights reserved.
//

import UIKit

class VideosViewController: CommentableViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

	@IBOutlet var collectionView: UICollectionView!
	@IBOutlet var labelTitle: UILabel!
	@IBOutlet var buttonRefresh: UIButton!
	@IBOutlet var activityIndicator: UIActivityIndicatorView!
	@IBOutlet var imageViewRating: UIImageView!
	
	var prevIndexPath: NSIndexPath? = nil
	
	var videosManager = VideosManager()
	
    override func viewDidLoad() {
        super.viewDidLoad()

		NSNotificationCenter.defaultCenter().addObserver(self, selector: "videosLoaded", name: kVideosLoadedNotification, object: nil)
		
		buttonRefresh.hidden = true
		activityIndicator.startAnimating()
		
		videosManager.loadVideos()
		
		imageViewRating.image = nil
		buttonComments.hidden = true
    }

	deinit {
		NSNotificationCenter.defaultCenter().removeObserver(self)
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		GANTracker.sharedInstance.trackView("videa")
	}

	// MARK: - UICollectionView
	
	func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return videosManager.videos.count
	}

	func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier("VideoCell", forIndexPath: indexPath) as! VideoCell
		
		cell.setVideoObject(videosManager.videos[indexPath.row])
		
		return cell
	}
	
	func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
		return collectionView.frame.size
	}
	
	// MARK: - Data
	
	func videosLoaded()
	{
		collectionView.reloadData()
		buttonRefresh.hidden = false
		activityIndicator.stopAnimating()
		
		if videosManager.videos.count > 0 {
			let videoObj = videosManager.videos[0]
			
			labelTitle.text = videoObj.name
			imageViewRating.image = UIImage(named: "icon_rating_" + String(videoObj.rating))
			buttonComments.hidden = false
			
			self.currentObject = videoObj
		}
	}
	
	@IBAction func onRefresh(sender: UIButton) {
		buttonRefresh.hidden = true
		activityIndicator.startAnimating()
		videosManager.loadVideos()
	}
	
	// MARK: - Rotation
	
	override func willRotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
		super.willRotateToInterfaceOrientation(toInterfaceOrientation, duration: duration)
		
		self.prevIndexPath = collectionView.indexPathsForVisibleItems()[0]
		collectionView.reloadData()
		collectionView.hidden = true
		collectionView.collectionViewLayout.invalidateLayout()
	}
	
	override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
		super.didRotateFromInterfaceOrientation(fromInterfaceOrientation)
		
		collectionView.scrollToItemAtIndexPath(self.prevIndexPath!, atScrollPosition: .CenteredHorizontally, animated: false)
		collectionView.hidden = false
	}

	func scrollViewDidScroll(scrollView: UIScrollView) {
		let index = Int((scrollView.contentOffset.x + scrollView.frame.size.width / 2) / scrollView.frame.size.width)
		
		if videosManager.videos.count > 0 {
			let videoObj = videosManager.videos[index]
			
			labelTitle.text = videoObj.name
			imageViewRating.image = UIImage(named: "icon_rating_" + String(videoObj.rating))
			buttonComments.hidden = false
			
			self.currentObject = videoObj
		}
	}
	
	@IBAction func onComments(sender: UIButton) {
		self.toggleComments()
	}
	
	override func getCurrentObject() -> FunnyObject? {
		let visibleRect = CGRectMake(collectionView.contentOffset.x, collectionView.contentOffset.y, collectionView.bounds.width, collectionView.bounds.height)
		let visiblePoint = CGPointMake(CGRectGetMidX(visibleRect), CGRectGetMidY(visibleRect))
		if let visibleIndexPath = collectionView.indexPathForItemAtPoint(visiblePoint) {
			return videosManager.videos[visibleIndexPath.row]
		} else {
			return nil
		}
	}
	
}
