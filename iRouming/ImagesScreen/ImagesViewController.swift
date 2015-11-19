//
//  ImagesViewController.swift
//  iRouming
//
//  Created by Lope on 19/11/15.
//  Copyright © 2015 Lost Bytes. All rights reserved.
//

import UIKit

class ImagesViewController: UITableViewController {
	var imagesManager: ImagesManager!
	
    override func viewDidLoad() {
        super.viewDidLoad()

		self.title = "Rouming"
		
		self.refreshControl = UIRefreshControl()
		self.refreshControl!.tintColor = UIColor.whiteColor()
		self.refreshControl!.addTarget(self, action: "pullDownToReloadAction", forControlEvents: .ValueChanged)
		
		self.tableView.contentOffset = CGPointMake(0, -self.refreshControl!.frame.size.height)
		self.refreshControl!.beginRefreshing()
		
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "imagesLoaded", name: kImagesLoadedNotification, object: nil)
		
		self.imagesManager = ImagesManager()
		self.imagesManager.loadImages()
		
		//self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: self.navigationItem.backBarButtonItem!.style, target: nil, action: nil)
    }
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		GANTracker.sharedInstance.trackView("kecy")
	}
	
	deinit {
		NSNotificationCenter.defaultCenter().removeObserver(self)
	}

    // MARK: - Table view data source

	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.imagesManager.images.count
	}

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ImageCell", forIndexPath: indexPath) as! ImagesCell

		cell.setImageObject(self.imagesManager.images[indexPath.row])
		
		// Remove seperator inset
		cell.separatorInset = UIEdgeInsetsZero
		
		// Prevent the cell from inheriting the Table View's margin settings
		cell.preservesSuperviewLayoutMargins = false
		
		// Explictly set your cell's layout margins
		cell.layoutMargins = UIEdgeInsetsZero

        return cell
    }
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "Info" {

		} else {
			//let vc = segue.destinationViewController as! GalleryViewController
			//vc.currentIndex = self.tableView.indexPathForSelectedRow!.row
		}
	}

	func imagesLoaded() {
		self.tableView.reloadData()
	
		self.refreshControl!.endRefreshing()
	}
	
	func pullDownToReloadAction() {
		self.imagesManager.loadImages()
	}
}
