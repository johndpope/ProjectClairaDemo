//
//  CharacterAlertView.swift
//  ClairaBellaDemo
//
//  Created by Vikash Kumar on 07/10/17.
//  Copyright © 2017 Vikash Kumar. All rights reserved.
//

import UIKit

class CharacterAlertView: UIView {
    
    @IBOutlet var webView: UIWebView!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblMessage: UILabel!
    
    var title: String = "" {
        didSet {
         lblTitle.text = title
        }
    }
    
    var message: String = "" {
        didSet {
            lblMessage.text = message
        }
    }
    
    var actionBlock: ((Int)-> Void)?
    
    
    class func show(in view: UIView, for character: Character)-> CharacterAlertView {
        let views = Bundle.main.loadNibNamed("CharacterAlertView", owner: nil, options: nil) as! [UIView]
        let alert = views.first as! CharacterAlertView
        view.addSubview(alert)
        
        alert.translatesAutoresizingMaskIntoConstraints = false
        alert.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        alert.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        alert.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        alert.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        
        alert.showWithAnimation()
        alert.webView.loadHTMLString(character.charHtml!, baseURL: nil)
        return alert
    }
    
    
    func showWithAnimation() {
        self.alpha = 0
    
        UIView.animate(withDuration: 0.3) { 
            self.alpha = 1
        }
    }
    
    func hideWithAnimation() {
        
        UIView.animate(withDuration: 0.3, animations: { 
            self.alpha = 0
            }) { (finish) in
                self.removeFromSuperview()
        }

    }
    
    
    //IBActions
    @IBAction func close_btnClicked(_ sender: UIButton) {
        actionBlock?(2)
        hideWithAnimation()
    }
    
    @IBAction func Ok_btnClicked(_ sender: UIButton) {
        actionBlock?(1)
        hideWithAnimation()

    }
    
}

class BorderButton: UIButton {
    
    @IBInspectable var borderColor: UIColor = .blue
    @IBInspectable var borderWidth: CGFloat = 1.0
    @IBInspectable var cornerRadius: CGFloat = 3.0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.borderColor = borderColor.cgColor
        self.layer.borderWidth = borderWidth
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = true
    }
}


