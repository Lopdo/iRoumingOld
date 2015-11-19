//
//  AboutViewController.swift
//  iRouming
//
//  Created by Lope on 19/11/15.
//  Copyright © 2015 Lost Bytes. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {
	@IBOutlet var viewLB: UIView!
	@IBOutlet var viewJD: UIView!
	@IBOutlet var viewRouming: UIView!
	@IBOutlet var viewPSpacerTop: UIView!
	@IBOutlet var viewPSpacerBottom: UIView!
	@IBOutlet var viewLSpacer: UIView!
	
	var customConstraints = [NSLayoutConstraint]()
	
    override func viewDidLoad() {
        super.viewDidLoad()

		self.viewLB.translatesAutoresizingMaskIntoConstraints = false
		self.viewJD.translatesAutoresizingMaskIntoConstraints = false
		
		let orientation = UIApplication.sharedApplication().statusBarOrientation
		if UIInterfaceOrientationIsLandscape(orientation) {
			self.setupLandscapeConstraints()
		} else {
			self.setupPortraitConstraints()
		}
    }

	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		GANTracker.sharedInstance.trackView("about")
	}
	
	@IBAction func onClose(sender: UIButton) {
		self.dismissViewControllerAnimated(true, completion: nil)
	}
	
	@IBAction func roumingPressed(sender: UIButton) {
		GANTracker.sharedInstance.trackView("external/rouming")
		UIApplication.sharedApplication().openURL(NSURL(string: "http://http://www.rouming.cz")!)
	}
	
	@IBAction func lbPressed(sender: UIButton) {
		GANTracker.sharedInstance.trackView("external/lostbytes")
		UIApplication.sharedApplication().openURL(NSURL(string: "http://www.lost-bytes.com")!)
	}
	
	@IBAction func ddPressed(sender: UIButton) {
		GANTracker.sharedInstance.trackView("external/daodesign")
		UIApplication.sharedApplication().openURL(NSURL(string: "http://www.justdesign.sk")!)
	}
	
	override func willRotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
		if UIInterfaceOrientationIsPortrait(toInterfaceOrientation) {
			self.setupPortraitConstraints()
		} else {
			self.setupLandscapeConstraints()
		}
	
		self.view.setNeedsUpdateConstraints()
		UIView.animateWithDuration(0.3) { () -> Void in
			self.view.layoutIfNeeded()
		}
	}
	
	func setupPortraitConstraints() {
		self.view.removeConstraints(self.customConstraints)
		self.customConstraints.removeAll()
		
		var c = NSLayoutConstraint(item: self.viewLB, attribute: .Top, relatedBy: .Equal,
								   toItem: self.viewRouming, attribute: .Bottom, multiplier: 1, constant: 0)
		self.view.addConstraint(c)
		self.customConstraints.append(c)
		
		c = NSLayoutConstraint(item: self.viewLB, attribute: .Bottom, relatedBy: .Equal,
			toItem: self.viewPSpacerTop, attribute: .Top, multiplier: 1, constant: 0)
		self.view.addConstraint(c)
		self.customConstraints.append(c)
		
		c = NSLayoutConstraint(item: self.viewLB, attribute: .Trailing, relatedBy: .Equal,
			toItem: self.view, attribute: .Trailing, multiplier: 1, constant: 0)
		self.view.addConstraint(c)
		self.customConstraints.append(c)
	
		c = NSLayoutConstraint(item: self.viewLB, attribute: .Leading, relatedBy: .Equal,
			toItem: self.view, attribute: .Leading, multiplier: 1, constant: 0)
		self.view.addConstraint(c)
		self.customConstraints.append(c)
		
		c = NSLayoutConstraint(item: self.viewLB, attribute: .Height, relatedBy: .Equal,
			toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 164)
		self.view.addConstraint(c)
		self.customConstraints.append(c)
		
		c = NSLayoutConstraint(item: self.viewJD, attribute: .Top, relatedBy: .Equal,
			toItem: self.viewPSpacerTop, attribute: .Bottom, multiplier: 1, constant: 0)
		self.view.addConstraint(c)
		self.customConstraints.append(c)
		
		c = NSLayoutConstraint(item: self.viewJD, attribute: .Bottom, relatedBy: .Equal,
			toItem: self.viewPSpacerBottom, attribute: .Top, multiplier: 1, constant: 0)
		self.view.addConstraint(c)
		self.customConstraints.append(c)
		
		c = NSLayoutConstraint(item: self.viewJD, attribute: .Trailing, relatedBy: .Equal,
			toItem: self.view, attribute: .Trailing, multiplier: 1, constant: 0)
		self.view.addConstraint(c)
		self.customConstraints.append(c)
		
		c = NSLayoutConstraint(item: self.viewJD, attribute: .Leading, relatedBy: .Equal,
			toItem: self.view, attribute: .Leading, multiplier: 1, constant: 0)
		self.view.addConstraint(c)
		self.customConstraints.append(c)
		
		c = NSLayoutConstraint(item: self.viewJD, attribute: .Height, relatedBy: .Equal,
			toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 164)
		self.view.addConstraint(c)
		self.customConstraints.append(c)
		
		c = NSLayoutConstraint(item: self.viewPSpacerBottom, attribute: .Height, relatedBy: .Equal,
			toItem: self.viewPSpacerTop, attribute: .Height, multiplier: 1, constant: 0)
		self.view.addConstraint(c)
		self.customConstraints.append(c)
	}
	
	func setupLandscapeConstraints() {
		self.view.removeConstraints(self.customConstraints)
		self.customConstraints.removeAll()
		
		var c = NSLayoutConstraint(item: self.viewLB, attribute: .Top, relatedBy: .Equal,
			toItem: self.viewRouming, attribute: .Bottom, multiplier: 1, constant: 0)
		self.view.addConstraint(c)
		self.customConstraints.append(c)
		
		c = NSLayoutConstraint(item: self.viewLB, attribute: .Bottom, relatedBy: .Equal,
			toItem: self.view, attribute: .Bottom, multiplier: 1, constant: 0)
		self.view.addConstraint(c)
		self.customConstraints.append(c)
		
		c = NSLayoutConstraint(item: self.viewJD, attribute: .Top, relatedBy: .Equal,
			toItem: self.viewRouming, attribute: .Bottom, multiplier: 1, constant: 0)
		self.view.addConstraint(c)
		self.customConstraints.append(c)
		
		c = NSLayoutConstraint(item: self.viewJD, attribute: .Bottom, relatedBy: .Equal,
			toItem: self.view, attribute: .Bottom, multiplier: 1, constant: 0)
		self.view.addConstraint(c)
		self.customConstraints.append(c)
		
		c = NSLayoutConstraint(item: self.viewLB, attribute: .Width, relatedBy: .Equal,
			toItem: self.viewJD, attribute: .Width, multiplier: 1, constant: 0)
		self.view.addConstraint(c)
		self.customConstraints.append(c)
		
		c = NSLayoutConstraint(item: self.viewLB, attribute: .Leading, relatedBy: .Equal,
			toItem: self.view, attribute: .Leading, multiplier: 1, constant: 0)
		self.view.addConstraint(c)
		self.customConstraints.append(c)
		
		c = NSLayoutConstraint(item: self.viewLB, attribute: .Trailing, relatedBy: .Equal,
			toItem: self.viewLSpacer, attribute: .Leading, multiplier: 1, constant: 0)
		self.view.addConstraint(c)
		self.customConstraints.append(c)
		
		c = NSLayoutConstraint(item: self.viewJD, attribute: .Trailing, relatedBy: .Equal,
			toItem: self.view, attribute: .Trailing, multiplier: 1, constant: 0)
		self.view.addConstraint(c)
		self.customConstraints.append(c)
		
		c = NSLayoutConstraint(item: self.viewJD, attribute: .Leading, relatedBy: .Equal,
			toItem: self.viewLSpacer, attribute: .Trailing, multiplier: 1, constant: 0)
		self.view.addConstraint(c)
		self.customConstraints.append(c)
	}
}
