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
            didStartBlock?()
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
                try UIImageJPEGRepresentation(image, 1.0)!.write(to: URL(fileURLWithPath: savePath))

            } catch {
                //
            }
            self.loadNextEmoji()
            
        }
        
    }
    

    
    func generateEmojiImage()->UIImage {
        let renderer = UIGraphicsImageRenderer(size: self.bounds.size)
        let image = renderer.image { ctx in
            self.drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        }
        return image
    }
    

    func fileExistAt(path: String)->Bool {
        return filemanager.fileExists(atPath: path)
    }
    

    func webViewDidFinishLoad(_ webView: UIWebView) {
        if !webView.isLoading {
            print("loading finish \(currntIndex)")
            save(emoji: currentEmoji, savePath: emojiSavePath)
        }
    }
    
}