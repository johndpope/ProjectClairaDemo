//
//  CarouselItemView.swift
//  ClairaBellaDemo
//
//  Created by Vikash Kumar on 31/08/17.
//  Copyright © 2017 Vikash Kumar. All rights reserved.
//

import UIKit


class CarouselItemView: UIView {
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var webView: UIWebView!
    @IBOutlet weak var webviewWidth: NSLayoutConstraint!
    
    @IBOutlet weak var webViewLeadingSpace: NSLayoutConstraint!
    
    var htmlString: String! {
        didSet {
            webView.loadHTMLString(htmlString, baseURL: nil)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //webViewLeadingSpace.constant = -70 * widthRatio
        
//        var zoomFac:CGFloat = 1.1
//        switch UIScreen.main.bounds.width {
//        case 320:
//            zoomFac = 1.1
//        case 375:
//            zoomFac = 1.3
//        case 414:
//            zoomFac = 1.3
//        default:
//            zoomFac = 1.1
//        }
//        
//        webView.scrollView.setZoomScale(zoomFac, animated: false)
        webView?.scrollView.isScrollEnabled = false
    }
    
    class func loadView()-> CarouselItemView {
        let views = Bundle.main.loadNibNamed("CarouselItemView", owner: nil, options: nil) as! [UIView]
        return views.first as! CarouselItemView
    }
    
    class func loadLastTile()-> CarouselItemView {
        let views = Bundle.main.loadNibNamed("CarouselItemView", owner: nil, options: nil) as! [UIView]
        return views[1] as! CarouselItemView
    }

}
