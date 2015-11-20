//
//  CommentsViewController.swift
//  iRouming
//
//  Created by Lope on 19/11/15.
//  Copyright © 2015 Lost Bytes. All rights reserved.
//

import UIKit

class CommentsViewController: UITableViewController {

	var constraintHeight: NSLayoutConstraint!
	
	var object: FunnyObject? {
		didSet {
			if let obj = object {
				obj.loadComments(false)
			}
			
			self.tableView.reloadData()
		}
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()

		NSNotificationCenter.defaultCenter().addObserver(self, selector: "commentsLoaded:", name: kCommentsLoadedNotification, object: nil)
		
		self.refreshControl!.addTarget(self, action: "pullDownToReloadAction", forControlEvents: .ValueChanged)
		
		/*if self.object.loadingComments {
			self.tableView.setContentOffset(CGPointMake(0, self.tableView.contentOffset.y - self.refreshControl!.frame.size.height), animated: true)
			self.refreshControl!.beginRefreshing()
		}*/
    }

	deinit {
		NSNotificationCenter.defaultCenter().removeObserver(self)
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		self.initConstraints()
	}
	
	func commentsLoaded(notification: NSNotification) {
		if self.object == nil || self.object!.Id != (notification.object as! FunnyObject).Id {
			return
		}
		
		self.refreshControl!.endRefreshing()
		self.tableView.reloadData()
	}
	
    // MARK: - Table view data source

	static var sizingTextView: UITextView? = nil

	func heightForBasicCellAtIndexPath(indexPath: NSIndexPath) -> CGFloat {
		if(CommentsViewController.sizingTextView == nil) {
			CommentsViewController.sizingTextView = UITextView()
			CommentsViewController.sizingTextView!.font = UIFont(name: "Titillium-Thin", size: 13)
			CommentsViewController.sizingTextView!.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
		}
		
		let comment = self.object!.comments[indexPath.row]
		CommentsViewController.sizingTextView!.text = comment.message
		
		let size = CommentsViewController.sizingTextView!.sizeThatFits(CGSizeMake(self.view.frame.size.width - 20, CGFloat(FLT_MAX)))
		return size.height + 36 + 1
	}
	
	override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return self.heightForBasicCellAtIndexPath(indexPath)
	}
	
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if let obj = self.object {
			return obj.comments.count
		} else {
			return 0
		}
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("CommentCell", forIndexPath:indexPath) as! CommentCell
		
		let comment = self.object!.comments[indexPath.row]
		cell.setCommentObject(comment)
		
		// Remove seperator inset
		cell.separatorInset = UIEdgeInsetsZero
		
		// Prevent the cell from inheriting the Table View's margin settings
		cell.preservesSuperviewLayoutMargins = false
		
		// Explictly set your cell's layout margins
		cell.layoutMargins = UIEdgeInsetsZero
		
		return cell
	}

	func initConstraints() {
		let viewsDictionary = ["tableView":self.tableView]
		
		let constraint_V = NSLayoutConstraint.constraintsWithVisualFormat("V:[tableView(0)]",
			options: NSLayoutFormatOptions(rawValue: 0),
			metrics: nil, views: viewsDictionary)
		
		self.constraintHeight = constraint_V[0]

		let constraint_POS_H = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[tableView]-0-|",
			options: NSLayoutFormatOptions(rawValue: 0),
			metrics: nil, views: viewsDictionary)
		
		let constraint_POS_V = NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[tableView]",
			options: NSLayoutFormatOptions(rawValue: 0),
			metrics: nil, views: viewsDictionary)

		self.view.superview!.addConstraints(constraint_V)
		self.view.superview!.addConstraints(constraint_POS_H)
		self.view.superview!.addConstraints(constraint_POS_V)
	}
	
	func pullDownToReloadAction() {
		if let obj = self.object {
			obj.loadComments(true)
		}
	}

}
