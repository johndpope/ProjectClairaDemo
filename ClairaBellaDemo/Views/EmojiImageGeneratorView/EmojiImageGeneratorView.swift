//
//  EmojiImageGeneratorView.swift
//  ClairaBellaDemo
//
//  Created by Vikash Kumar on 15/10/17.
//  Copyright © 2017 Vikash Kumar. All rights reserved.
//

import UIKit

class EmojiImageGeneratorView : UIView, UIWebViewDelegate {
    @IBOutlet var webView: UIWebView!
   
    var character: Character! {
        didSet {
            if !character.emojis.isEmpty {
                currntIndex = -1
                
                self.loadNextEmoji()
            }
        }
    }
    
    var charGenerator = CharacterHTMLBuilder.shared
    var currntIndex = -1
    let filemanager = FileManager.default
    var currentEmoji: Emoji!
    
    var completionBlock: (()->())?
    var didStartBlock: (()->())?
    var didImageCapturedForEmojiBlock: ((Emoji)->())?
    
    var emojiSavePath: String {
        let url = filemanager.containerURL(forSecurityApplicationGroupIdentifier: appGroupName)!.appendingPathComponent((character.createdDate) + "/" + currentEmoji.key)
        return url.path
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        webView.delegate = self
    }
    
    
    func loadNextEmoji() {
        currntIndex += 1
        let emojiCount = character.emojis.count
        print(currntIndex)
        if currntIndex < emojiCount {
            if currntIndex == 0 {
                didStartBlock?()
            }
            currentEmoji = character.emojis[currntIndex]
            
            let url = filemanager.containerURL(forSecurityApplicationGroupIdentifier: appGroupName)!.appendingPathComponent((character.createdDate) + "/" + currentEmoji.key)
            
            if fileExistAt(path: url.path) {
                loadNextEmoji()
                
            } else {
                if currentEmoji.charHtml.isEmpty {
                    charGenerator.buildCharHTMLWith(for: .emoji, choices: character!.choices, for: currentEmoji.key) { (html) in
                        self.webView.loadHTMLString(html, baseURL: nil)
                    }
                } else {
                    DispatchQueue.main.async{
                        self.webView.loadHTMLString(self.currentEmoji.charHtml, baseURL: nil)
                    }
                }
            }
        }
        
        if currntIndex >= (emojiCount-1) {
            completionBlock?()
        }
    }

    func save( emoji: Emoji, savePath: String) {
        let directoryURl = self.filemanager.containerURL(forSecurityApplicationGroupIdentifier: appGroupName)!.appendingPathComponent( self.character.createdDate)
        
        let direcotryPath = directoryURl.path
       
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) {
            let image = self.generateEmojiImage()
            
            if !self.filemanager.fileExists(atPath: direcotryPath) {
                do {
                    try self.filemanager.createDirectory(atPath: direcotryPath, withIntermediateDirectories: true, attributes: nil)
                } catch {
                    //
                }
            }
            do {
                if let img = image {
                    try UIImageJPEGRepresentation(img, 1.0)!.write(to: URL(fileURLWithPath: savePath))
                }
                self.didImageCapturedForEmojiBlock?(emoji)
            } catch {
                //
            }
            self.loadNextEmoji()
            
        }
        
    }
    

    
    func generateEmojiImage()->UIImage? {
        
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.isOpaque, 2.0)
        if let context = UIGraphicsGetCurrentContext() {
            self.layer.render(in: context)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return image
        }
        return nil
    }
    

    func fileExistAt(path: String)->Bool {
        return filemanager.fileExists(atPath: path)
    }
    

    func webViewDidFinishLoad(_ webView: UIWebView) {
        if !webView.isLoading {
            print("loading finish \(currntIndex)")
            //webView.scrollView.contentInset = UIEdgeInsets(top: 25, left: 0, bottom: -25, right: 0)
            save(emoji: currentEmoji, savePath: emojiSavePath)
        }
    }
    
}
