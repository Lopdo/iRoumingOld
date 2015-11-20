//
//  CommentCell.swift
//  iRouming
//
//  Created by Lope on 19/11/15.
//  Copyright © 2015 Lost Bytes. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell, UITextViewDelegate {

	@IBOutlet var labelAuthor: UILabel!
	@IBOutlet var labelDate: UILabel!
	@IBOutlet var textViewText: UITextView!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
		textViewText.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }

	private static var df: NSDateFormatter? = nil
	
	func setCommentObject(commentObject: CommentObject) {
		
		if CommentCell.df == nil {
			CommentCell.df = NSDateFormatter()
			CommentCell.df!.dateFormat = "(dd.MM.YYYY hh:mm)"
		}
		
		self.textViewText.text = commentObject.message
		self.labelDate.text = CommentCell.df!.stringFromDate(commentObject.date)
		if commentObject.registered {
			let authorString =  NSMutableAttributedString(string: commentObject.nick + " (R)")
			authorString.setAttributes([NSFontAttributeName: UIFont(name: "Titillium-Semibold", size: 12)!], range: NSMakeRange(authorString.length - 2, 1))
			self.labelAuthor.attributedText = authorString
		}
		else {
			self.labelAuthor.text = commentObject.nick
		}
	}
	
	func textView(textView: UITextView, shouldInteractWithURL URL: NSURL, inRange characterRange: NSRange) -> Bool {
		return true
	}

}
