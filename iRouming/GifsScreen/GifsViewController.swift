//
//  GifsViewController.swift
//  iRouming
//
//  Created by Lope on 19/11/15.
//  Copyright © 2015 Lost Bytes. All rights reserved.
//

import UIKit

class GifsViewController: CommentableViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

	@IBOutlet var collectionView: UICollectionView!
	@IBOutlet var labelTitle: UILabel!
	@IBOutlet var buttonRefresh: UIButton!
	@IBOutlet var activityIndicator: UIActivityIndicatorView!
	@IBOutlet var imageViewRating: UIImageView!

	var prevIndexPath: NSIndexPath? = nil
	
	var gifsManager = GifsManager()
	
    override func viewDidLoad() {
        super.viewDidLoad()

		NSNotificationCenter.defaultCenter().addObserver(self, selector: "gifsLoaded", name: kGifsLoadedNotification, object: nil)
		
		buttonRefresh.hidden = true
		activityIndicator.startAnimating()
		gifsManager.loadGifs()
		
		imageViewRating.image = nil
		buttonComments.hidden = true
    }

	deinit {
		NSNotificationCenter.defaultCenter().removeObserver(self)
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		GANTracker.sharedInstance.trackView("gify")
	}
    
	// MARK: - UICollectionView
	func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return gifsManager.gifs.count
	}

	func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
		return collectionView.frame.size
	}
	
	func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier("GifCell", forIndexPath: indexPath) as! GifCell
		
		cell.setGifObject(gifsManager.gifs[indexPath.row])
		
		return cell
	}

	// MARK: - Data
	
	func gifsLoaded() {
		collectionView.reloadData()
		buttonRefresh.hidden = false
		activityIndicator.stopAnimating()
		
		if gifsManager.gifs.count > 0 {
			let gifObj = gifsManager.gifs[0]
			
			labelTitle.text = gifObj.name
			imageViewRating.image = UIImage(named: "icon_rating_" + String(gifObj.rating))
			buttonComments.hidden = false
			
			self.currentObject = gifObj
		}
	}
	
	@IBAction func onRefresh(sender: UIButton) {
		buttonRefresh.hidden = true
		activityIndicator.startAnimating()
		gifsManager.loadGifs()
	}
	
	override func getCurrentObject() -> FunnyObject? {
		let visibleRect = CGRectMake(collectionView.contentOffset.x, collectionView.contentOffset.y, collectionView.bounds.width, collectionView.bounds.height)
		let visiblePoint = CGPointMake(CGRectGetMidX(visibleRect), CGRectGetMidY(visibleRect))
		if let visibleIndexPath = collectionView.indexPathForItemAtPoint(visiblePoint) {
			return gifsManager.gifs[visibleIndexPath.row]
		} else {
			return nil
		}
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
		
		collectionView.scrollToItemAtIndexPath(self.prevIndexPath!, atScrollPosition:.CenteredHorizontally, animated:false)
		collectionView.hidden = false
	}
	
	func scrollViewDidScroll(scrollView: UIScrollView) {
		let index = Int((scrollView.contentOffset.x + scrollView.frame.size.width / 2) / scrollView.frame.size.width)
		
		if gifsManager.gifs.count > 0 {
			let gifObj = gifsManager.gifs[index]
			
			labelTitle.text = gifObj.name
			imageViewRating.image = UIImage(named: "icon_rating_" + String(gifObj.rating))
			buttonComments.hidden = false
			
			self.currentObject = gifObj
		}
	}
	
	@IBAction func onComments(sender: UIButton) {
		self.toggleComments()
	}

}
