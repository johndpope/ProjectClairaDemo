//
//  ShareCharacterView.swift
//  ClairaBellaDemo
//
//  Created by Vikash Kumar on 01/10/17.
//  Copyright © 2017 Vikash Kumar. All rights reserved.
//

import UIKit

class ShareCharacterView: UIView {
    @IBOutlet var cardView: UIView!
    @IBOutlet var webView: UIWebView!
    @IBOutlet var backgroundImage: UIImageView!
    
    var character: CharacterType! {
        didSet {
            
            webView.loadHTMLString(character.charHtml, baseURL: nil)
            
            if character is Character {
                let ch = character as! Character
                if let backImageName = ch.characterBackground?.image {
                    backgroundImage.image = UIImage(named: backImageName)
                }

            }
        }
    }
    
    enum ShareOptions: Int {
        case facebook = 1, twitter, mail, save, more
    }
    
    var actionBlock: ((ShareOptions, UIImage)-> Void)?
    
    //Private funcs
    fileprivate func showAnimation() {
        self.alpha = 0
    UIView.animate(withDuration: 0.3) { 
        self.alpha = 1.0
        }
    }
    
    fileprivate func hideWithAnimation() {
        self.alpha = 1
        UIView.animate(withDuration: 0.3, animations: { 
            self.alpha = 0
            }) { (finish) in
                self.removeFromSuperview()
        }
    }
    
    //IBActions
    @IBAction func close_btnClicked(_ sender: UIButton) {
        hideWithAnimation()
    }

    
    @IBAction func shareOption_btnClicked(_ sender: UIButton) {
        if let option = ShareOptions(rawValue: sender.tag) {
            actionBlock?(option, self.generateImage())
        }
    }

    
    func generateImage()->UIImage {
        let renderer = UIGraphicsImageRenderer(size: cardView.bounds.size)
        let image = renderer.image { ctx in
            self.cardView.drawHierarchy(in: cardView.bounds, afterScreenUpdates: true)
        }
        return image

    }
}

//Class functions
extension ShareCharacterView {
    class func show(in view: UIView, character: CharacterType, actionBlock: ((ShareOptions, UIImage)->Void)? = nil) {
        let views = Bundle.main.loadNibNamed("ShareCharacterView", owner: nil, options: nil) as! [UIView]
       
        let scView = ((character is Character ) ? views.first : views[1]) as! ShareCharacterView
        let scviewFrame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        scView.frame = scviewFrame
        view.addSubview(scView)
       
        scView.showAnimation()
        
        scView.character = character
        scView.actionBlock = actionBlock
        
        
    }

}
