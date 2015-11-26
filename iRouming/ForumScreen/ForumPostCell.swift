//
//  ForumPostCell.swift
//  iRouming
//
//  Created by Lope on 19/11/15.
//  Copyright © 2015 Lost Bytes. All rights reserved.
//

import UIKit

class ForumPostCell: UITableViewCell, UITextViewDelegate {

	@IBOutlet var labelAuthor: UILabel!
	@IBOutlet var labelDate: UILabel!
	@IBOutlet var labelTitle: UILabel!
	@IBOutlet var textViewText: UITextView!
	
    override func awakeFromNib() {
        super.awakeFromNib()
		
		self.textViewText.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
		self.textViewText.linkTextAttributes = [ NSForegroundColorAttributeName: UIColor(red: 0, green: 157.0 / 255.0, blue: 224.0 / 255.0, alpha: 1)]
    }

	static var df: NSDateFormatter? = nil
	
	func setPostObject(postObject: ForumPostObject) {

		if ForumPostCell.df == nil {
			ForumPostCell.df = NSDateFormatter()
			ForumPostCell.df!.dateFormat = "(dd.MM.YYYY hh:mm)"
		}
		
		textViewText.attributedText = postObject.htmlMessage;
		labelTitle.text = postObject.title;
		labelDate.text = ForumPostCell.df!.stringFromDate(postObject.date)
		if postObject.registered {
			let authorString = NSMutableAttributedString(string: postObject.nick + " (R)")
			authorString.setAttributes([NSFontAttributeName: UIFont(name: "Titillium-Semibold", size: 12)!], range: NSMakeRange(authorString.length - 2, 1))
			labelAuthor.attributedText = authorString
		}
		else {
			labelAuthor.text = postObject.nick
		}
	}
	
	func textView(textView: UITextView, shouldInteractWithURL URL: NSURL, inRange characterRange: NSRange) -> Bool {
		return true
	}

}
