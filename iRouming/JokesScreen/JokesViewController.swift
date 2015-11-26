//
//  JokesViewController.swift
//  iRouming
//
//  Created by Lope on 19/11/15.
//  Copyright © 2015 Lost Bytes. All rights reserved.
//

import UIKit

class JokesViewController: UITableViewController {

	var jokesManager = JokesManager()
	
	override func viewDidLoad() {
		super.viewDidLoad()

		self.edgesForExtendedLayout = UIRectEdge.None
		self.extendedLayoutIncludesOpaqueBars = false
		self.automaticallyAdjustsScrollViewInsets = false
		
		self.refreshControl = UIRefreshControl()
		self.refreshControl!.tintColor = UIColor.whiteColor()
		self.refreshControl!.addTarget(self, action: "pullDownToReloadAction", forControlEvents: .ValueChanged)
		
		self.tableView.contentOffset = CGPointMake(0, -self.refreshControl!.frame.size.height)
		self.refreshControl!.beginRefreshing()
		
		//self.edgesForExtendedLayout = UIRectEdge.None
		//self.extendedLayoutIncludesOpaqueBars = false
		//self.automaticallyAdjustsScrollViewInsets = false
		
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "jokesLoaded", name: kJokesLoadedNotification, object: nil)
		
		self.jokesManager.loadJokes()
    }

	deinit {
		NSNotificationCenter.defaultCenter().removeObserver(self)
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		GANTracker.sharedInstance.trackView("vtipy")
	}
	
	// MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.jokesManager.jokes.count == 0 ? 0 : self.jokesManager.jokes.count + 1
    }

	static var sizingCell: JokeCell?
	static var onceToken: dispatch_once_t = 0
	
	func heightForBasicCellAtIndexPath(indexPath: NSIndexPath) -> CGFloat {
		dispatch_once(&JokesViewController.onceToken) { () -> Void in
			JokesViewController.sizingCell = self.tableView.dequeueReusableCellWithIdentifier("JokeCell") as? JokeCell
			JokesViewController.sizingCell!.frame = CGRectMake(0, 0, self.view.frame.size.width, 64)
		}
		
		JokesViewController.sizingCell!.setJokeObject(self.jokesManager.jokes[indexPath.row])
		
		return self.calculateHeightForConfiguredSizingCell(JokesViewController.sizingCell!)
	}
	
	func calculateHeightForConfiguredSizingCell(sizingCell: UITableViewCell) -> CGFloat {
		sizingCell.setNeedsLayout()
		sizingCell.layoutIfNeeded()
 
		let size = sizingCell.contentView.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize)
		return size.height + 1.0 // Add 1.0f for the cell separator height
	}

	override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		if indexPath.row == self.jokesManager.jokes.count {
			return 64
		}
		
		return self.heightForBasicCellAtIndexPath(indexPath)
	}
	
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		if indexPath.row == self.jokesManager.jokes.count {
			let cell = tableView.dequeueReusableCellWithIdentifier("LoadingCell", forIndexPath:indexPath) as! LoadingCell
			
			self.jokesManager.loadNextPage()
			
			// Remove seperator inset
			cell.separatorInset = UIEdgeInsetsZero
			
			// Prevent the cell from inheriting the Table View's margin settings
			cell.preservesSuperviewLayoutMargins = false
			
			// Explictly set your cell's layout margins
			cell.layoutMargins = UIEdgeInsetsZero
			
			return cell
		}
		else {
			let cell = tableView.dequeueReusableCellWithIdentifier("JokeCell", forIndexPath:indexPath) as! JokeCell
			
			cell.setJokeObject(self.jokesManager.jokes[indexPath.row])
			
			// Remove seperator inset
			cell.separatorInset = UIEdgeInsetsZero
			
			// Prevent the cell from inheriting the Table View's margin settings
			cell.preservesSuperviewLayoutMargins = false
			
			// Explictly set your cell's layout margins
			cell.layoutMargins = UIEdgeInsetsZero
			
			return cell
		}
	}
	
	func jokesLoaded() {
		self.tableView.reloadData()
	
		self.refreshControl!.endRefreshing()
	}
	
	func pullDownToReloadAction() {
		self.jokesManager.loadJokes()
	}
}
