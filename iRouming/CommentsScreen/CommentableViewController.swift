//
//  CommentableViewController.swift
//  iRouming
//
//  Created by Lope on 19/11/15.
//  Copyright © 2015 Lost Bytes. All rights reserved.
//

import UIKit

class CommentableViewController: UIViewController {

	@IBOutlet var buttonComments: CommentsButton!
	
	var commentsVC: CommentsViewController!
	var commentsViewTop: NSLayoutConstraint!
	
	var commentsOffsetY: CGFloat = 0
	
	var currentObject: FunnyObject! {
		didSet {
			if currentObject.loadingComments {
				self.buttonComments.setCommentCount(-1)
			} else {
				self.buttonComments.setCommentCount(currentObject.comments.count)
			}
			
			self.commentsVC.object = currentObject
		}
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()

		self.commentsOffsetY = 44
		
		self.commentsVC = self.storyboard!.instantiateViewControllerWithIdentifier("CommentsViewController") as! CommentsViewController
		self.commentsVC.view.translatesAutoresizingMaskIntoConstraints = false;
		
		self.view.addSubview(self.commentsVC.view)
		
		self.commentsViewTop = NSLayoutConstraint(item: self.commentsVC.view, attribute: .Top, relatedBy: .Equal,
												toItem: self.view, attribute: .Top, multiplier: 1, constant: self.view.frame.size.height)
		self.view.addConstraint(self.commentsViewTop)
		
		var c = NSLayoutConstraint(item: self.commentsVC.view, attribute: .Bottom, relatedBy: .Equal,
									toItem: self.view, attribute: .Bottom, multiplier: 1, constant: 0)
		self.view.addConstraint(c)
		
		c = NSLayoutConstraint(item: self.commentsVC.view, attribute: .Trailing, relatedBy: .Equal,
			toItem: self.view, attribute: .Trailing, multiplier: 1, constant: 0)
		self.view.addConstraint(c)
		
		c = NSLayoutConstraint(item: self.commentsVC.view, attribute: .Leading, relatedBy: .Equal,
			toItem: self.view, attribute: .Leading, multiplier: 1, constant: 0)
		self.view.addConstraint(c)
		
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "onCommentsLoaded:", name: kCommentsLoadedNotification, object: nil)
    }

	deinit {
		NSNotificationCenter.defaultCenter().removeObserver(self)
	}
	
	override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
		super.didRotateFromInterfaceOrientation(fromInterfaceOrientation)
		
		if self.commentsViewTop.constant != self.topLayoutGuide.length + self.commentsOffsetY {
			self.commentsViewTop.constant = self.view.frame.size.height
		}
		
		self.view.setNeedsUpdateConstraints()
		self.view.layoutIfNeeded()
	}
	
	func onCommentsLoaded(notification: NSNotification) {
		if self.currentObject.loadingComments {
			self.buttonComments.setCommentCount(-1)
		} else {
			self.buttonComments.setCommentCount(self.currentObject.comments.count)
		}
	}
	
	func toggleComments() {
		if(self.commentsViewTop.constant == self.topLayoutGuide.length + self.commentsOffsetY) {
			self.commentsViewTop.constant = self.view.frame.size.height
		}
		else {
			self.commentsViewTop.constant = self.topLayoutGuide.length + self.commentsOffsetY
		}
		
		self.view.setNeedsUpdateConstraints()
		UIView.animateWithDuration(0.2) { () -> Void in
			self.view.layoutIfNeeded()
		}
	}
	
	func commentsVisible() -> Bool
	{
		return self.commentsViewTop.constant == self.topLayoutGuide.length + self.commentsOffsetY
	}
	
	func getCurrentObject() -> FunnyObject?
	{
		return nil
	}
	
}
