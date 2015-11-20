//
//  GalleryCell.swift
//  iRouming
//
//  Created by Lope on 19/11/15.
//  Copyright © 2015 Lost Bytes. All rights reserved.
//

import UIKit

class GalleryCell: UICollectionViewCell {

	@IBOutlet var imageScrollView: ImageScrollView!
	
	func setImageObject(imgObj: ImageObject) {
		self.imageScrollView.loadImage(imgObj)
	}

}
