//
//  EmojiImageGeneratorView.swift
//  ClairaBellaDemo
//
//  Created by Vikash Kumar on 15/10/17.
//  Copyright © 2017 Vikash Kumar. All rights reserved.
//

import UIKit

//let nonPersnolizedEmojis = ["EJ001", "EJ002","EJ003","EJ004","EJ005","EJ006",
//                            "EJ007", "EJ008","EJ009","EJ010","EJ011","EJ012",
//                            "EJ013", "EJ014","EJ015","EJ016","EJ017","EJ018",
//                            "EJ019", "EJ020","EJ021","EJ022","EJ023","EJ024",
//                            "EJ025", "EJ026","EJ027","EJ028","EJ029","EJ030",
//                            "EJ031", "EJ032","EJ033","EJ034","EJ035","EJ036",
//                            "EJ037", "EJ038","EJ039","EJ040","EJ041","EJ042",
//                            "EJ043", "EJ044","EJ045","EJ046","EJ047","EJ048",
//                            "EJ049", "EJ050","EJ051","EJ052","EJ053","EJ054","EJ055",
//                            "EJ056", "EJ057","EJ058","EJ059","EJ060","EJ061", "EJ062"]

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
//        let url = filemanager.containerURL(forSecurityApplicationGroupIdentifier: appGroupName)!.appendingPathComponent((character.createdDate) + "/" + currentEmoji.key)
        let url = currentEmoji.getEmojiURL(char: character)
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
            
            let url = currentEmoji.getEmojiURL(char: character)
            
            if fileExistAt(path: url.path) {
                return loadNextEmoji()
                
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
//        let isNonPersnolizedEmoji = nonPersnolizedEmojis.contains(emoji.key)
//        
//        let directoryName = isNonPersnolizedEmoji ? "NonPersnolizeEmoji" : self.character.createdDate
       
//        var directoryURl = self.filemanager.containerURL(forSecurityApplicationGroupIdentifier: appGroupName)!.appendingPathComponent(directoryName)
        let directoryURl = emoji.getSaveDirectoryURL(char: character)
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
                    //directoryURl.appendPathComponent("\(emoji.key)")
                    
                    //let pathToSave = isNonPersnolizedEmoji ? directoryURl : URL(fileURLWithPath: savePath)
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
            save(emoji: currentEmoji, savePath: emojiSavePath)
        }
    }
    
}
