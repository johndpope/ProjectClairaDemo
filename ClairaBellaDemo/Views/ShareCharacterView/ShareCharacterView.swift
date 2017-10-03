//
//  ShareCharacterView.swift
//  ClairaBellaDemo
//
//  Created by Vikash Kumar on 01/10/17.
//  Copyright © 2017 Vikash Kumar. All rights reserved.
//

import UIKit

class ShareCharacterView: UIView {
    @IBOutlet var webView: UIWebView!

    var character: Character! {
        didSet {
            webView.loadHTMLString(character.charHtml!, baseURL: nil)
        }
    }
    class func show(in view: UIView, character: Character) {
        let views = Bundle.main.loadNibNamed("ShareCharacterView", owner: nil, options: nil) as! [UIView]
        let scView = views.first as! ShareCharacterView
        let scviewFrame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        scView.frame = scviewFrame
        view.addSubview(scView)
        scView.showAnimation()
        scView.character = character
    }
    
    private func showAnimation() {
        self.alpha = 0
    UIView.animate(withDuration: 0.3) { 
        self.alpha = 1.0
        }
    }
    
    func hideWithAnimation() {
        self.alpha = 1
        UIView.animate(withDuration: 0.3, animations: { 
            self.alpha = 0
            }) { (finish) in
                self.removeFromSuperview()
        }
    }
    
    @IBAction func close_btnClicked(_ sender: UIButton) {
        hideWithAnimation()
    }


}
