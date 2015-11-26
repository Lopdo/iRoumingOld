//
//  VideoCell.swift
//  iRouming
//
//  Created by Lope on 19/11/15.
//  Copyright © 2015 Lost Bytes. All rights reserved.
//

import UIKit

class VideoCell: UICollectionViewCell, UIWebViewDelegate {

	@IBOutlet var webView: UIWebView!
	@IBOutlet var activityIndicator: UIActivityIndicatorView!
	
    override func awakeFromNib() {
        super.awakeFromNib()
		
		webView.scrollView.scrollEnabled = false
    }

	func setVideoObject(video: VideoObject) {
		webView.hidden = true
	
		let width = self.frame.size.width
		let height = self.frame.size.height
		
		do {
			let youTubeVideoHTML = try String(contentsOfFile: NSBundle.mainBundle().pathForResource("youtubeEmbed", ofType: "html")!, encoding: NSUTF8StringEncoding)
			let autoPlayString = ""
			//let autoPlayString = autoPlay ? "events: {'onReady' : onPlayerReady }," : "" //customise it weather u want to autoplay or not
			let controls = 1 //i want to show controles for play,pause,fullscreen ... etc
			let html = String(format: youTubeVideoHTML, arguments: [video.youtubeId, width, height, autoPlayString, controls]) //setting the youtube video width and height to fill entire the web view
			webView.mediaPlaybackRequiresUserAction = false
			webView.delegate = self
			webView.loadHTMLString(html, baseURL:NSBundle.mainBundle().resourceURL) //load it to webview
		} catch {

		}
	}
	
	func webViewDidFinishLoad(webView: UIWebView) {
		webView.hidden = false
		activityIndicator.stopAnimating()
	}
}
