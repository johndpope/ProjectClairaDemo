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
    @IBOutlet var btnGlobe: UIButton!
    @IBOutlet var btnGlobe2: UIButton!

    @IBOutlet var indicator: UIActivityIndicatorView!
    @IBOutlet var messageViewTop: NSLayoutConstraint!
    @IBOutlet var noFullAccessView: UIView!
    @IBOutlet var currentCharView: UIView!
    @IBOutlet var currentCharImageView: UIImageView!
    
    var filemanager = FileManager.default
    
    //var charGenerator = CharacterHTMLBuilder.shared
    
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
                if let char = self.selectedCharacter {
                    self.currentCharImageView.image = self.imageFor(char: char)
                }

                
            }
        }
    }
    
    
    weak var viewController: KeyboardViewController?
    
    var showCharters = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let nib = UINib(nibName: "EmojiCell", bundle: Bundle(for: KeyboardView.self))
        let nib2 = UINib(nibName: "CharacterCell", bundle: Bundle(for: KeyboardView.self))

        collView.register(nib, forCellWithReuseIdentifier: "emojiCell")
        collView.register(nib2, forCellWithReuseIdentifier: "charCell")
        collView.contentInset = UIEdgeInsets(top: 8, left: 15, bottom: 8, right: 15)
        noFullAccessView.isHidden = isFullAccessGranted()
        
        currentCharView.layer.cornerRadius = 27//currentCharView.frame.height/2
        currentCharView.clipsToBounds = true
        currentCharView.backgroundColor = UIColor(colorLiteralRed: 0.97 , green: 0.82, blue: 0.93, alpha: 1)
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
        DispatchQueue.main.async {
            self.collView.reloadData()
        }
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
            if indexPath.row == 0 {
                //cell.imgView.image = nil//UIImage(named: "BtnNewChar")
                cell.roundView.backgroundColor = UIColor(colorLiteralRed: 0.47, green: 0.84, blue: 0.23, alpha: 1)
                cell.lblTitle.text = "New"
                cell.imgView.clipsToBounds = true
                cell.tickMark.isHidden = true
                cell.imgView.isHidden = true
                
            } else {
                //cell.imgView.image = nil
                let char = characters[indexPath.row - 1]
                
                cell.imgView.image = imageFor(char: char)
                cell.imgView.contentMode = .scaleAspectFill
                cell.imgView.clipsToBounds = true
                
                cell.roundView.backgroundColor = UIColor(colorLiteralRed: 0.97 , green: 0.82, blue: 0.93, alpha: 1)
                cell.lblTitle.text = ""
                cell.tickMark.isHidden = selectedCharacter == char ? false : true
                cell.imgView.isHidden = false
            }
            
            cell.backgroundColor = UIColor.clear
            cell.roundView.isHidden = false
            let width = ((collectionView.frame.width -  60) / 4) - 4

            cell.roundView?.layer.cornerRadius = width/2
            cell.roundView?.clipsToBounds = true

            return cell

        } else { //cell for display emojies
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "emojiCell", for: indexPath) as! EmojiCell
            
            let emoji = selectedCharacter!.emojis[indexPath.item]
            cell.imgView.image = imageFor(emoji: emoji)
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - (showCharters ? 60 : 50)) / (showCharters ? 4 : 3)
        return CGSize(width: width, height:  width)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if showCharters {
            if indexPath.row == 0 {
                viewController?.openApp()
            } else {
                showCharters = !showCharters
                
                selectedCharacter = characters[indexPath.row - 1]
            }
        } else {
            let emoji = selectedCharacter!.emojis[indexPath.item]
            saveEmojiInPastboard(emoji: emoji)
            showAnimatingAlert()
        }
    }
    
    
}


//MARK:- Other Important Methods

extension KeyboardView {
    
    func imageFor(emoji: Emoji)-> UIImage? {
        let url = filemanager.containerURL(forSecurityApplicationGroupIdentifier: appGroupName)!.appendingPathComponent(selectedCharacter!.createdDate + "/" + emoji.key)
        
        do  {
            let data = try Data(contentsOf: url)
            let image = UIImage(data: data)
            return image
        } catch {
            
        }
        return nil
    }
    
    func imageFor(char: Character)-> UIImage? {
        let url = filemanager.containerURL(forSecurityApplicationGroupIdentifier: appGroupName)!.appendingPathComponent(char.createdDate + "/" + char.createdDate)
        
        do  {
            let data = try Data(contentsOf: url)
            let image = UIImage(data: data)
            return image
        } catch {
            
        }
        return nil
    }
    
    
    func saveEmojiInPastboard(emoji: Emoji) {
        let url = filemanager.containerURL(forSecurityApplicationGroupIdentifier: appGroupName)!.appendingPathComponent(selectedCharacter!.createdDate + "/" + emoji.key)
        
        do  {
            let data = try Data(contentsOf: url)
            let image = UIImage(data: data)
            let pasteBoard = UIPasteboard.general
            let imagedata = UIImagePNGRepresentation(image!)
            pasteBoard.setData(imagedata!, forPasteboardType: UIPasteboardTypeListImage.object(at: 0) as! String)
            
        } catch {
            
        }
    }
    
    func showAnimatingAlert() {
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

 func isFullAccessGranted() -> Bool {
    if #available(iOSApplicationExtension 10.0, *) {
        if UIPasteboard.general.hasStrings {
            return  true
        } else if UIPasteboard.general.hasURLs {
            return true
        } else if UIPasteboard.general.hasColors {
            return true
        } else if UIPasteboard.general.hasImages {
            return true
        } else { // In case the pasteboard is blank
            UIPasteboard.general.string = ""
            
            if UIPasteboard.general.hasStrings {
                return  true
            } else {
                return  false
            }
        }
    } else {
        // before iOS10
        return UIPasteboard.general.isKind(of: UIPasteboard.self)
    }
}

