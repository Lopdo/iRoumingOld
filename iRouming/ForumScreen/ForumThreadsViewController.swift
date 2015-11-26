//
//  ForumThreadsViewController.swift
//  iRouming
//
//  Created by Lope on 19/11/15.
//  Copyright © 2015 Lost Bytes. All rights reserved.
//

import UIKit

let kForumThreadSelectedNotification = "ForumThreadSelectedNotification"

class ForumThreadsViewController: UITableViewController {

	var forumManager = ForumManager()
	var threadList: [ForumThreadObject]?
	
	override func viewDidLoad() {
		super.viewDidLoad()

		NSNotificationCenter.defaultCenter().addObserver(self, selector: "forumThreadListLoaded:", name: kForumThreadListLoadedNotification, object: nil)
		
		self.forumManager.loadThreadList()
		
		self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0)
    }

	deinit {
		NSNotificationCenter.defaultCenter().removeObserver(self)
	}
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		
		if self.forumManager.loadingThreads {
			self.refreshControl = UIRefreshControl()
			self.refreshControl!.tintColor = UIColor.whiteColor()
			self.refreshControl!.addTarget(self, action: "pullDownToReloadAction", forControlEvents: .ValueChanged)
			
			self.tableView.contentOffset = CGPointMake(0, -self.refreshControl!.frame.size.height - 20)
			self.refreshControl!.beginRefreshing()
		}
	}
	
    // MARK: - Table view data source

	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if let list = self.threadList {
			return list.count + 2
		}
		
		return 2
    }
	
	override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		if let list = self.threadList {
			if indexPath.row == list.count + 1 {
				return 50
			}
		}
		
		return 32
	}

	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("ForumThreadCell", forIndexPath: indexPath) as! ForumThreadCell
		
		if indexPath.row == 0 {
			cell.labelCount.hidden = true
			cell.labelTitle.text = "Všechna vlákna"
		}
		else {
			if let list = self.threadList {
				if indexPath.row == list.count + 1 {
					cell.labelCount.hidden = true
					cell.labelTitle.text = ""
				}
				else {
					cell.labelCount.hidden = false;
					cell.setThreadObject(list[indexPath.row - 1])
				}
			}
		}
		
		// Remove seperator inset
		cell.separatorInset = UIEdgeInsetsZero
		
		// Prevent the cell from inheriting the Table View's margin settings
		cell.preservesSuperviewLayoutMargins = false
		
		// Explictly set your cell's layout margins
		cell.layoutMargins = UIEdgeInsetsZero
		
		return cell
	}
	
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		tableView.cellForRowAtIndexPath(indexPath)?.setSelected(false, animated: true)
		
		var threadId: UInt = 0
		if let list = self.threadList {
			threadId = indexPath.row == 0 ? 0 : list[indexPath.row - 1].threadId
		}
		NSNotificationCenter.defaultCenter().postNotificationName(kForumThreadSelectedNotification, object: nil, userInfo: ["threadId": threadId])
	}
	
	// MARK: - Data
	
	func forumThreadListLoaded(notification: NSNotification) {
		self.threadList = notification.userInfo!["threads"] as? [ForumThreadObject]
		self.tableView.reloadData()
		self.refreshControl!.endRefreshing()
	}
	
	func pullDownToReloadAction() {
		self.forumManager.loadThreadList()
	}

}
