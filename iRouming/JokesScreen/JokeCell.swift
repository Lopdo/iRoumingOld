//
//  JokeCell.swift
//  iRouming
//
//  Created by Lope on 19/11/15.
//  Copyright © 2015 Lost Bytes. All rights reserved.
//

import UIKit

class JokeCell: UITableViewCell {
	
	@IBOutlet var labelName: UILabel!
	@IBOutlet var labelText: UILabel!
	@IBOutlet var labelCategory: UILabel!
	@IBOutlet var imageViewRating: UIImageView!

	func setJokeObject(jokeObj: JokeObject) {
		labelName.text = jokeObj.name
		labelCategory.text = jokeObj.category
		labelText.text = jokeObj.text
		
		imageViewRating.image = UIImage(named: "icon_rating_" + String(jokeObj.rating))
	}
}
