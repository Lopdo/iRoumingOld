//
//  GalleryViewController.swift
//  iRouming
//
//  Created by Lope on 19/11/15.
//  Copyright © 2015 Lost Bytes. All rights reserved.
//

import UIKit

class GalleryViewController: CommentableViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

	@IBOutlet var collectionView: UICollectionView!
	@IBOutlet var labelLikes: UILabel!
	@IBOutlet var viewTitle: UIView!
	
	@IBOutlet var activityIndicatorSave: UIActivityIndicatorView!
	@IBOutlet var buttonSave: UIButton!
	
	var currentIndex: Int = -1
	
	var labelTitle: UILabel!
	var fullscreen: Bool = false
	var prevIndexPath: NSIndexPath? = nil
	
	var imagesManager: ImagesManager!
	
    override func viewDidLoad() {
        super.viewDidLoad()

		self.labelTitle = UILabel(frame: CGRectMake(0, 0, 280, 44))
		self.labelTitle.textAlignment = .Center
		self.labelTitle.numberOfLines = 2;
		self.labelTitle.lineBreakMode = .ByWordWrapping
		self.labelTitle.adjustsFontSizeToFitWidth = true
		self.labelTitle.textColor = UIColor.whiteColor()
		self.navigationItem.titleView = self.labelTitle
		
		let layout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
		layout.itemSize = self.collectionView.frame.size
		
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "handleImageTap", name: kGalleryImageDoubleTapNotification, object: nil)
    }

	deinit {
		NSNotificationCenter.defaultCenter().removeObserver(self)
	}
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
	
		self.view.layoutSubviews()
	
		if self.currentIndex != -1 {
			self.collectionView.scrollToItemAtIndexPath(NSIndexPath(forRow: self.currentIndex, inSection: 0), atScrollPosition: .CenteredHorizontally, animated: false)
			
			// if we are opening first photo, we dont scroll, so we need to set this stuff manually
			if self.currentIndex == 0 {
				self.updateImageData(self.imagesManager.images[self.currentIndex])
			}
			
			self.currentIndex = -1
		}
	}
	
	func handleImageTap() {
		// FIX: position of title view is off, either on rotation or on status bar hide/show
		if self.fullscreen {
			UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: .Fade)
			
			UIView.animateWithDuration(0.4, animations: { () -> Void in
				self.navigationController!.navigationBar.alpha = 1
				self.viewTitle.alpha = 0.8
				self.navigationController!.setNeedsStatusBarAppearanceUpdate()
			})
		} else {
			UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: .Fade)
			
			UIView.animateWithDuration(0.4, animations: { () -> Void in
				self.navigationController!.navigationBar.alpha = 0
				self.navigationController!.setNeedsStatusBarAppearanceUpdate()
				self.viewTitle.alpha = 0
			})
		}
		self.fullscreen = !self.fullscreen
	}
	
	override func viewWillDisappear(animated: Bool) {
		super.viewWillDisappear(animated)
	
		if UIDeviceOrientationIsPortrait(UIDevice.currentDevice().orientation) {
			UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: .Fade)
		}
	
		self.navigationController!.navigationBar.alpha = 1
	}
	
	// MARK: - UICollectionView
	
	func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return self.imagesManager.images.count
	}

	func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier("GalleryCell", forIndexPath: indexPath) as! GalleryCell
		
		cell.setImageObject(self.imagesManager.images[indexPath.row])
		
		return cell
	}
	
	func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
		return collectionView.frame.size
	}

	// MARK: - Rotation
	
	override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
		super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
		
		if let collectionView = collectionView {
			if collectionView.indexPathsForVisibleItems().count > 0 {
				self.prevIndexPath = collectionView.indexPathsForVisibleItems()[0]
				collectionView.reloadData()
				collectionView.hidden = true
				collectionView.collectionViewLayout.invalidateLayout()
			}
		}
		
		coordinator.animateAlongsideTransition(nil) { (_) -> Void in
			if let collectionView = self.collectionView, prevIndexPath = self.prevIndexPath {
				collectionView.scrollToItemAtIndexPath(prevIndexPath, atScrollPosition: .CenteredHorizontally, animated: false)
				collectionView.hidden = false
			}
		}
	}
	
	func scrollViewDidScroll(scrollView: UIScrollView) {
		let index = Int((scrollView.contentOffset.x + scrollView.frame.size.width / 2) / scrollView.frame.size.width)
		
		self.updateImageData(self.imagesManager.images[index])
	}
	
	func updateImageData(imgObj: ImageObject) {
		self.labelTitle.text = imgObj.name
		self.setLikes(imgObj.likes, dislikes:imgObj.dislikes)
		self.currentObject = imgObj
	}
	
	func setLikes(likes: UInt, dislikes: UInt) {
		
		let likesStr = String(likes) + " / " + String(dislikes)
	
		let attributedString = NSMutableAttributedString(string: likesStr, attributes: [NSFontAttributeName: UIFont.boldSystemFontOfSize(17), NSForegroundColorAttributeName: UIColor.whiteColor()])
		
		let separatorPos = likesStr.rangeOfString("/")?.startIndex
		let separatorOffset = likesStr.startIndex.distanceTo(separatorPos!)
		attributedString.setAttributes([NSForegroundColorAttributeName: UIColor(red: 55.0 / 255.0, green: 232.0 / 255.0, blue: 14.0 / 255.0, alpha: 1)], range:  NSMakeRange(0, separatorOffset))
		attributedString.setAttributes([NSForegroundColorAttributeName: UIColor(red: 243.0 / 255.0, green: 1.0 / 255.0, blue: 1.0 / 255.0, alpha: 1)], range:  NSMakeRange(separatorOffset + 1, separatorPos!.distanceTo(likesStr.endIndex) - 1))
	
		self.labelLikes.attributedText = attributedString
	}
	
	@IBAction func onComments(sender: UIButton) {
		self.toggleComments()
		
		if self.commentsVisible() {
			self.viewTitle.backgroundColor = UIColor(white: 0, alpha: 1)
		}
		else {
			self.viewTitle.backgroundColor = UIColor(white:0, alpha:0.42)
		}
	}
	
	@IBAction func onSave(sender: UIButton) {
		
	}
	
	@IBAction func onShare(sender: UIButton) {
		// Create the item to share (in this example, a url)
		let url = NSURL(string: (self.currentObject as! ImageObject).urlImage)
		let item = SHKItem.URL(url, title: "", contentType: SHKURLContentTypeWebpage) as! SHKItem
		
		// Get the ShareKit action sheet
		//SHKActionSheet *actionSheet = [SHKActionSheet actionSheetForItem:item];
		
		// ShareKit detects top view controller (the one intended to present ShareKit UI) automatically,
		// but sometimes it may not find one. To be safe, set it explicitly
		SHK.setRootViewController(self)
		
		let alertController = SHKAlertController.actionSheetForItem(item)
		alertController.modalPresentationStyle = .Popover
		let popPresenter = alertController.popoverPresentationController!
		popPresenter.barButtonItem = self.toolbarItems![1]
		self.presentViewController(alertController, animated: true, completion: nil)
	}

}
