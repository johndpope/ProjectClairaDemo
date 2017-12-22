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
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var tickMark: UIImageView!
    @IBOutlet var roundView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if roundView != nil {
//            roundView.layer.cornerRadius = roundView.frame.size.height/2
//            roundView.clipsToBounds = true
        }
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        if roundView != nil {
//            roundView.layer.cornerRadius = roundView.frame.size.height/2
//            roundView.clipsToBounds = true
        }
    }
}
