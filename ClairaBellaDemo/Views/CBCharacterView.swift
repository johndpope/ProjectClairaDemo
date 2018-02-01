//
//  CBCharacterView.swift
//  ClairaBellaDemo
//
//  Created by Vikash Kumar on 30/01/18.
//  Copyright © 2018 Vikash Kumar. All rights reserved.
//

import UIKit


class CBCharacterView: UIView {
    
    let webView = UIWebView()
    let imageView = UIImageView()
    
    weak var characterGenerator:CharacterHTMLBuilder?
    
    var character: Character! {
        didSet {
            setCharacterImage()
        }
    }
    
        
    var charImage: UIImage?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //setUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let rect = CGRect(x: -75, y: -25, width: 250, height: 400)
        webView.frame = rect
        
        imageView.frame = self.bounds
    }
    
    
    func setUI() {
        webView.scalesPageToFit = true
        webView.isOpaque = false
        webView.backgroundColor = UIColor.clear
        webView.delegate = self
    
        addSubview(webView)
        
        imageView.contentMode = .scaleAspectFit
        addSubview(imageView)
    }
    
    func setCharacterImage() {
        imageView.isHidden = true
        webView.isHidden = true

        if let charImage = character.image {
            imageView.image = charImage
            imageView.isHidden = false
        } else {
            webView.isHidden = false
            loadHtml()
        }
    }
    
    func loadHtml() {
        if  !character.charHtml.isEmpty {
            webView.loadHTMLString(character.charHtml, baseURL: nil)
        } else {
            if let charGenerator = self.characterGenerator {
                charGenerator.buildCharHTMLWith(choices: character.choices, block: {[unowned self] html in
                    self.character.charHtml = html
                    self.webView.loadHTMLString(self.character.charHtml, baseURL: nil)
                })
            }
        }
    }
}

extension CBCharacterView : UIWebViewDelegate {
    func webViewDidStartLoad(_ webView: UIWebView) {
        
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        if !webView.isLoading {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                if let img = self.generateImage() {
                    self.character.image = img
                    self.imageView.image = img
                    self.webView.isHidden = true
                    self.imageView.isHidden = false
                }
            }
        }
    }
}
