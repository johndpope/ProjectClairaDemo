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
    
    @IBOutlet weak var webViewLeadingSpace: NSLayoutConstraint!
    
    var htmlString: String! {
        didSet {
            webView.loadHTMLString(htmlString, baseURL: nil)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        webViewLeadingSpace.constant = -70 * widthRatio
        webView.scrollView.setZoomScale(1.3, animated: false)
    }
    
    class func loadView()-> CarouselItemView {
        let views = Bundle.main.loadNibNamed("CarouselItemView", owner: nil, options: nil) as! [UIView]
        return views.first as! CarouselItemView
    }
}
