//
//  CustomSHKConfigurator.swift
//  iRouming
//
//  Created by Lope on 19/11/15.
//  Copyright © 2015 Lost Bytes. All rights reserved.
//

import UIKit

class CustomSHKConfigurator: DefaultSHKConfigurator {
	override func sharersPlistName() -> String
	{
		return "iRoumingSharerSettings.plisoverride t"
	}
	
	override func showActionSheetMoreButton() -> NSNumber
	{
		return NSNumber(bool: false)
	}
	
	override func defaultFavoriteURLSharers() -> [AnyObject]
	{
		return ["SHKTwitter", "SHKiOSTwitter", "SHKFacebook", "SHKiOSFacebook"]
	}
	
	override func facebookAppId() -> String
	{
		return "868619806493352"
	}
}
