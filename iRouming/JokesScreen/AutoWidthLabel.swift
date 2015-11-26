//
//  AutoWidthLabel.swift
//  iRouming
//
//  Created by Lope on 19/11/15.
//  Copyright © 2015 Lost Bytes. All rights reserved.
//

import UIKit

class AutoWidthLabel: UILabel {

	override func layoutSubviews() {
		super.layoutSubviews()
		
		self.preferredMaxLayoutWidth = CGRectGetWidth(self.bounds)
		
		super.layoutSubviews()
	}

}
