//
//  ForumPostObject.swift
//  iRouming
//
//  Created by Lope on 18/11/15.
//  Copyright © 2015 Lost Bytes. All rights reserved.
//

import UIKit

class ForumPostObject: NSObject {
	var nick: String
	var title: String
	var message: String
	var htmlMessage: NSAttributedString
	var registered: Bool
	var threadId: UInt
	var date: NSDate
	
	init(jsonData: [NSString: AnyObject]) {
		self.nick = jsonData["nick"] as! String
		self.registered = Int(jsonData["registered"] as! String) == 1
		self.threadId = UInt(jsonData["thread"] as! String)!
		self.date = NSDate(timeIntervalSince1970: Double(jsonData["timestamp"] as! String)!)
		self.title = jsonData["description"] as! String
		self.message = jsonData["message"] as! String
		
		var tmpString = self.message.stringByReplacingOccurrencesOfString("[i]", withString: "<i>")
		tmpString = tmpString.stringByReplacingOccurrencesOfString("[/i]", withString:"</i>")
		tmpString = tmpString.stringByReplacingOccurrencesOfString("[b]", withString:"<b>")
		tmpString = tmpString.stringByReplacingOccurrencesOfString("[/b]", withString:"</b>")
		tmpString = tmpString.stringByReplacingOccurrencesOfString("\n", withString:"<br />")
		
		do {
			self.htmlMessage = try NSAttributedString(data: tmpString.dataUsingEncoding(NSUTF8StringEncoding)!, options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType], documentAttributes: nil)
		} catch _ {
			self.htmlMessage = NSAttributedString(string: "")
		}
		
		let res = self.htmlMessage.mutableCopy() as! NSMutableAttributedString
		res.beginEditing()
		res.enumerateAttribute(NSFontAttributeName, inRange: NSMakeRange(0, res.length), options: NSAttributedStringEnumerationOptions(rawValue:0)) { (value, range, stop) -> Void in
			if (value != nil) {
				let oldFont = value as! UIFont
				var newFont: UIFont
				
				if oldFont.fontName.rangeOfString("italic", options: .CaseInsensitiveSearch, range: nil, locale: nil) != nil {
					newFont = UIFont(name: "Titillium-ThinItalic", size:13)!
				} else {
					newFont = UIFont(name: "Titillium-Thin", size:13)!
				}
				res.addAttribute(NSFontAttributeName, value: newFont, range: range)
			}
		}
		res.endEditing()
		res.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor(), range: NSMakeRange(0, res.length))
		
		self.htmlMessage = res
	}
}
