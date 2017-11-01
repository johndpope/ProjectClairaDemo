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
    @IBOutlet var messageViewTop: NSLayoutConstraint!
    
    var filemanager = FileManager.default
    var charGenerator = CharacterHTMLBuilder.shared
    
    var characters = [Character]() {
        didSet {
            selectedCharacter = characters.first
        }
    }
    var emojiTypes = [String]()
    
    var selectedCharacter: Character? {
        didSet {
            if selectedCharacter!.emojis.isEmpty {
                selectedCharacter?.emojis.removeAll()
                for type in emojiTypes {
                    let emoji = Emoji()
                    emoji.key = type
                    selectedCharacter?.emojis.append(emoji)
                }
            }
            print("selected character name : \(selectedCharacter!.name)")
            DispatchQueue.main.async {
                self.collView.reloadData()
            }
        }
    }
        
    var showCharters = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        collView.dataSource = nil
//        collView.delegate = nil
        let nib = UINib(nibName: "EmojiCell", bundle: Bundle(for: KeyboardView.self))
        let nib2 = UINib(nibName: "CharacterCell", bundle: Bundle(for: KeyboardView.self))

        collView.register(nib, forCellWithReuseIdentifier: "emojiCell")
        collView.register(nib2, forCellWithReuseIdentifier: "charCell")

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
    }
}

extension KeyboardView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return showCharters ? (characters.count + 1) : ( selectedCharacter == nil ? 0 : selectedCharacter!.emojis.count)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if showCharters { //cell for display characters
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "charCell", for: indexPath) as! EmojiCell
            cell.backgroundColor = UIColor.white
            if indexPath.row == 0 {
                cell.imgView.image = UIImage(named: "AddChars")
                cell.webView.isHidden = true
                //cell.backgroundColor = UIColor.white
            } else {
                cell.imgView.image = nil
                cell.webView.isHidden = false
                let char = characters[indexPath.row - 1]
                let url = filemanager.containerURL(forSecurityApplicationGroupIdentifier: appGroupName)!.appendingPathComponent(char.createdDate + "/" + char.createdDate)

                do  {
                    let data = try Data(contentsOf: url)
                    let image = UIImage(data: data)
                    cell.imgView.image = image
                } catch {
                    
                }

//                charGenerator.buildCharHTMLWith(for: .character, choices: char.choices) { (html) in
//                    cell.webView.loadHTMLString(html, baseURL: nil)
//                }
                
                cell.layer.cornerRadius = cell.frame.height/2
                cell.clipsToBounds = true
                //cell.backgroundColor = UIColor(colorLiteralRed: 230.0/255, green: 44.0/255.0, blue: 152.0/255.0, alpha: 1)
            }
            
            return cell

        } else { //cell for display emojies
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "emojiCell", for: indexPath) as! EmojiCell
            let emoji = selectedCharacter!.emojis[indexPath.item]
            cell.webView.loadRequest(URLRequest(url: URL(string: "about:blank")!))
            
            let url = filemanager.containerURL(forSecurityApplicationGroupIdentifier: appGroupName)!.appendingPathComponent(selectedCharacter!.createdDate + "/" + emoji.key)
            
            do  {
                let data = try Data(contentsOf: url)
                let image = UIImage(data: data)
                cell.imgView.image = image
            } catch {
                
            }
//            if emoji.charHtml.isEmpty {
//                charGenerator.buildCharHTMLWith(for: .emoji, choices: selectedCharacter!.choices, for: emoji.key) {[weak cell, weak emoji] (html) in
//                    
//                    cell?.webView.loadHTMLString(html, baseURL: nil)
//                    emoji?.charHtml = html
//                }
//
//            } else {
//
//                cell.webView.loadHTMLString(emoji.charHtml, baseURL: nil)
//            }
            //cell.backgroundColor = .black
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = showCharters ? 100 : ((collectionView.frame.width)/3)
        return CGSize(width: width, height:  width)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if showCharters {
            if indexPath.row == 0 {

            } else {
                showCharters = !showCharters
                selectedCharacter = characters[indexPath.row - 1]
            }
        } else {
            let emoji = selectedCharacter!.emojis[indexPath.item]
            let url = filemanager.containerURL(forSecurityApplicationGroupIdentifier: appGroupName)!.appendingPathComponent(selectedCharacter!.createdDate + "/" + emoji.key)
            
            do  {
                let data = try Data(contentsOf: url)
                let image = UIImage(data: data)
                let pasteBoard = UIPasteboard.general
                let imagedata = UIImagePNGRepresentation(image!)
                pasteBoard.setData(imagedata!, forPasteboardType: UIPasteboardTypeListImage.object(at: 0) as! String)
                
            } catch {
                
            }
            
            
            self.messageViewTop.constant = -50
            self.layoutIfNeeded()
            
            UIView.animate(withDuration: 0.3, animations: {
                self.messageViewTop.constant = 0
                self.layoutIfNeeded()
            }, completion: { (finish) in
                UIView.animate(withDuration: 0.3, delay: 1, options: [.curveEaseInOut], animations: {
                    self.messageViewTop.constant = -50
                    self.layoutIfNeeded()
                }, completion: { (finish) in
                })
            })
        }
    }
    
    func openApp() {
        let instagramHooks = "instagram://user?username=your_username"
        _ = URL(string: instagramHooks)
    }
}




extension UIImage {
    class func imageWithView(view: UIView) -> UIImage {
        //let drawSize = CGSize(width: view.bounds.size.width * 2 , height: view.bounds.size.height * 2)
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.isOpaque, 1.0)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }
}

