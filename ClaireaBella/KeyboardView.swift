//
//  KeyboardView.swift
//  ClairaBellaDemo
//
//  Created by Vikash Kumar on 26/09/17.
//  Copyright © 2017 Vikash Kumar. All rights reserved.
//

import UIKit

class KeyboardView: UIView {
    @IBOutlet var collView: UICollectionView!
    @IBOutlet var btnKeyboard: UIButton!
    @IBOutlet var indicator: UIActivityIndicatorView!
    
    var charGenerator = CharacterHTMLBuilder.shared
    
    var characters = [Character]() {
        didSet {
            selectedCharacter = characters.first
        }
    }
    
    var selectedCharacter: Character? {
        didSet {
            collView.reloadData()
        }
    }
    
    var emojiesTypes = [CharacterHTMLBuilder.ContextType.smilingEmoji, CharacterHTMLBuilder.ContextType.blinkingEmoji]
    
    var showCharters = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let nib = UINib(nibName: "EmojiCell", bundle: Bundle(for: KeyboardView.self))
        collView.register(nib, forCellWithReuseIdentifier: "emojiCell")
    }
   
    class func add(in view: UIView)-> KeyboardView {
        let views = Bundle(for: KeyboardView.self).loadNibNamed("KeyboardView", owner: nil, options: nil) as! [UIView]
        
        let keyboardView = views.first as! KeyboardView
        keyboardView.frame = view.bounds
        view.addSubview(keyboardView)
        
        return keyboardView
    }
    
    @IBAction func changeChar_btnClicked(_ sender: UIButton) {
        showCharters = !showCharters
        collView.reloadData()
        
        let pasteBoard = UIPasteboard.general
        let image = UIImage(named: "tempChart1")
        let imagedata = UIImagePNGRepresentation(image!)
        pasteBoard.setData(imagedata!, forPasteboardType: UIPasteboardTypeListImage.object(at: 0) as! String)
    }
}

extension KeyboardView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return showCharters ? (characters.count + 1) : ( selectedCharacter == nil ? 0 : emojiesTypes.count)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if showCharters { //cell for display characters
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "emojiCell", for: indexPath) as! EmojiCell
            if indexPath.row == 0 {
                cell.imgView.image = UIImage(named: "AddChars")
                cell.webView.isHidden = true
                
            } else {
                cell.imgView.image = nil
                cell.webView.isHidden = false
                
                let char = characters[indexPath.row - 1]
                charGenerator.buildCharHTMLWith(choices: char.choices, for: CharacterHTMLBuilder.ContextType.appPreview) { (html) in
                    cell.webView.loadHTMLString(html, baseURL: nil)
                }
            }
            
            return cell

        } else { //cell for display emojies
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "emojiCell", for: indexPath) as! EmojiCell
            let emojiType = emojiesTypes[indexPath.item]
            charGenerator.buildCharHTMLWith(choices: selectedCharacter!.choices, for: emojiType) { (html) in
                cell.webView.loadHTMLString(html, baseURL: nil)
            }
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = showCharters ? 100 : 60
        return CGSize(width: height, height: height)
    }
    
    
    func openApp() {
        var instagramHooks = "instagram://user?username=your_username"
        var instagramUrl = URL(string: instagramHooks)
    }
}


class EmojiCell: UICollectionViewCell {
    @IBOutlet var webView: UIWebView!
    @IBOutlet var imgView: UIImageView!
    
}
