//
//  ForumViewController.swift
//  iRouming
//
//  Created by Lope on 19/11/15.
//  Copyright © 2015 Lost Bytes. All rights reserved.
//

import UIKit

class ForumViewController: UITableViewController {

	var currentThreadId: UInt = 0
	
	@IBOutlet var revealButtonItem: UIBarButtonItem!
	var posts: [ForumPostObject]? = nil
	
	var forumManager = ForumManager()
	
	override func viewDidLoad() {
		super.viewDidLoad()

		self.refreshControl?.addTarget(self, action: "pullDownToReloadAction", forControlEvents: .ValueChanged)
		
		self.tableView.setContentOffset(CGPointMake(0, self.tableView.contentOffset.y - self.refreshControl!.frame.size.height), animated: true)

		self.refreshControl!.beginRefreshing()
		
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "forumPostsLoaded:", name: kForumThreadLoadedNotification, object: nil)
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "onThreadChanged:", name: kForumThreadSelectedNotification, object: nil)
		
		let revealViewController = self.revealViewController()
		if revealViewController != nil {
			revealViewController.rightViewRevealWidth = 220
			self.revealButtonItem.target = revealViewController
			self.revealButtonItem.action = "revealToggle:"
			self.navigationController!.navigationBar.addGestureRecognizer(revealViewController.panGestureRecognizer())
			self.view.addGestureRecognizer(revealViewController.panGestureRecognizer())
		}
		
		self.forumManager.loadForum()
    }

	deinit {
		NSNotificationCenter.defaultCenter().removeObserver(self)
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		GANTracker.sharedInstance.trackView("forum")
	}
	
    // MARK: - Table view data source

	static var sizingTextView: UITextView? = nil
	func heightForRowAtIndexPath(indexPath: NSIndexPath) -> CGFloat {
		if ForumViewController.sizingTextView == nil {
			ForumViewController.sizingTextView = UITextView()
			ForumViewController.sizingTextView!.font = UIFont(name: "Titillium-Thin", size: 13)
			ForumViewController.sizingTextView!.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
		}
		
		if let posts = self.posts {
			let post = posts[indexPath.row]
			ForumViewController.sizingTextView!.text = post.message;
			
			let size = ForumViewController.sizingTextView!.sizeThatFits(CGSizeMake(self.view.frame.size.width - 20, CGFloat(FLT_MAX)))
			return size.height + 36 + 1
			
		} else {
			return 36
		}
	}
	
	override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return self.heightForRowAtIndexPath(indexPath)
	}
	
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if let posts = self.posts {
			return posts.count
		} else {
			return 0
		}
	}

	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("ForumPostCell", forIndexPath: indexPath) as! ForumPostCell
		
		if let posts = self.posts {
			cell.setPostObject(posts[indexPath.row])
		}
		
		// Remove seperator inset
		cell.separatorInset = UIEdgeInsetsZero
		
		// Prevent the cell from inheriting the Table View's margin settings
		cell.preservesSuperviewLayoutMargins = false
		
		// Explictly set your cell's layout margins
		cell.layoutMargins = UIEdgeInsetsZero
		
		return cell
	}
	
	// MARK: - Data
	
	func forumPostsLoaded(notification: NSNotification) {
		if self.currentThreadId != notification.userInfo!["threadId"] as! UInt {
			return
		}
		
		self.posts = notification.userInfo!["posts"] as? [ForumPostObject]
		
		self.tableView.reloadData()
		
		self.refreshControl!.endRefreshing()
	}
	
	func pullDownToReloadAction() {
		if self.currentThreadId == 0 {
			self.forumManager.loadForum()
		}
		else {
			self.forumManager.loadThread(self.currentThreadId)
		}
	}
	
	func onThreadChanged(notification: NSNotification) {
		self.tableView.setContentOffset(CGPointMake(0, self.tableView.contentOffset.y - self.refreshControl!.frame.size.height), animated:true)
		self.refreshControl!.beginRefreshing()
		if self.posts != nil {
			self.posts!.removeAll()
		}
		self.tableView.reloadData()
	
		self.currentThreadId = notification.userInfo!["threadId"] as! UInt
		self.forumManager.loadThread(self.currentThreadId)
		self.revealViewController().revealToggleAnimated(true)
	}

}
