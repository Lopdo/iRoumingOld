//
//  GANTracker.swift
//  iRouming
//
//  Created by Lope on 19/11/15.
//  Copyright © 2015 Lost Bytes. All rights reserved.
//

import UIKit

class GANTracker: NSObject {
	
	static let sharedInstance = GANTracker()
	
	func trackView(viewName: String) {
		let tracker = GAI.sharedInstance().defaultTracker
		tracker.set(kGAIScreenName, value: viewName)
		
		let builder = GAIDictionaryBuilder.createScreenView()
		tracker.send(builder.build() as [NSObject : AnyObject])
	}
}
