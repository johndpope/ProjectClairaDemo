//
//  KeyboardCell.swift
//  ClairaBellaDemo
//
//  Created by Vikash Kumar on 05/10/17.
//  Copyright © 2017 Vikash Kumar. All rights reserved.
//

import UIKit



class EmojiCell: UICollectionViewCell {
    @IBOutlet var webView: UIWebView!
    @IBOutlet var imgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        webView.scrollView.setZoomScale(2.0, animated: false)
    }
}
