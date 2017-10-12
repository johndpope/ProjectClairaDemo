
//
//  EmojiesVC.swift
//  Claireabella
//
//  Created by Intelivita on 05/05/17.
//  Copyright © 2017 Intelivita. All rights reserved.
//

import UIKit
import Social

class EmojiesVC: ParentVC {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var emoji_uiimage: UIImageView!
    
    var character: Character?
    var charGenerator = CharacterHTMLBuilder.shared

    var emojisContextKeys = [String]() {
        didSet {
            character?.emojis.removeAll()
            for type in emojisContextKeys {
                let emoji = Emoji()
                emoji.key = type
                emoji.charHtml = ""
                character?.emojis.append(emoji)
            }

            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //tableView.dataSource = nil
        //tableView.delegate = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getEmojisContexts()
       
        if let char = characterForEmoji {
            character = char
            characterForEmoji = nil
        }

        if character == nil {
            if !Character.myCharacters.isEmpty {
                if let defaultChar = Character.mainCharacter {
                    character = defaultChar
                } else {
                    character = Character.myCharacters.first!
                    
                }
                tableView.dataSource = self
                tableView.delegate = self

            }
        } else {
            tableView.dataSource = self
            tableView.delegate = self
        }

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        characterForEmoji = nil
        character = nil
    }

    @IBAction func Btn_HomeAct(_ sender: UIBarButtonItem) {
        tabBarController?.selectedIndex = 0
    }
   
    @IBAction func Btn_SetupNowAction(_ sender: UIButton) {
       self.performSegue(withIdentifier: "KeyBoardSegue", sender: nil)

    }
    
    @IBAction func change_CharacterAction(_ sender: UIButton) {
        tabBarController?.selectedIndex = 1
    }
    
    @IBAction func Btn_ShareEmojiAction(_ sender: UIButton) {
        let VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ShareVC")
        VC.modalPresentationStyle = .overCurrentContext
        self.present(VC, animated: false, completion: nil)
        
    }
    
}

extension EmojiesVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  1 + (character == nil ? 0 : 1)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "bannerCell")!
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "emojiesCell") as! EmojiTableViewCell
            cell.collectionview.reloadData()
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let bannerCellHeight = 186 * widthRatio
        if indexPath.row == 0 {
            return bannerCellHeight
        } else {
            return SCREEN_HEIGHT - bannerCellHeight - 64 - 49
        }
        
    }
}

extension EmojiesVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return   character?.emojis.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "emojiCell", for: indexPath) as! EmojiItemCell
            let emoji = character!.emojis[indexPath.item]
            if emoji.charHtml.isEmpty {
                charGenerator.buildCharHTMLWith(for: .emoji, choices: character!.choices, for: emoji.key) { (html) in
                    cell.webView.loadHTMLString(html, baseURL: nil)
                    emoji.charHtml = html
                }
                
            } else {
                cell.webView.loadHTMLString(emoji.charHtml, baseURL: nil)
            }
            //cell.backgroundColor = UIColor.black
            return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width-8)/4
        return CGSize(width: width, height: width)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let emoji = character!.emojis[indexPath.item]
        
            charGenerator.buildCharHTMLWith(for: .emoji, choices: character!.choices, for: emoji.key) { (html) in
                //  cell.webView.loadHTMLString(html, baseURL: nil)
                emoji.charHtml = html
            }
            
      
        ShareCharacterView.show(in: self.view, character: emoji) { (action, image) in
           
            switch action {
            case .facebook:
                self.shareOnFacebook(image)
            case .twitter:
                print("twitter")
                self.shareOnTwitter(image)
            case .mail:
                print("mail") 
            case .save:
                self.saveToPhots(image)
            case .more:
                print("more")
                self.moreShare(image: image)
            }
        }

    }
    
    
    
    func shareOnFacebook(_ image: UIImage) {
        if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeFacebook) {
            let vc = SLComposeViewController(forServiceType:SLServiceTypeFacebook)!
            vc.add(image)
            //        vc.add(URL(string: "http://www.example.com/"))
            //        vc.setInitialText("Initial text here.")
            
            self.present(vc, animated: true, completion: nil)
        } else {
            showAlert(message: "Please go to settings > Facebook and add your facebook account. ")
        }
    }
    
    
    func shareOnTwitter(_ image: UIImage) {
        if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter) {
            let vc = SLComposeViewController(forServiceType:SLServiceTypeTwitter)!
            vc.add(image)
            //        vc.add(URL(string: "http://www.example.com/"))
            //        vc.setInitialText("Initial text here.")
            
            self.present(vc, animated: true, completion: nil)
        } else {
            showAlert(message: "Please go to settings > Twitter and add your twitter account. ")
        }
    }
    
    func saveToPhots(_ image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    func imageDidSaveToPhotoAlbum() {
        print("save done")
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your character image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
    func moreShare(image: UIImage)  {
        let activityVC = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        self.present(activityVC, animated: true, completion: nil)
    }
}

extension EmojiesVC {
    func getEmojisContexts() {
        APICall.shared.emojis_context_APICall { (response, success) in
            if success {
                if let json = response as? [String : Any] {
                    let emojisTypes = json.map({$0.key})
                    print(emojisTypes)
                    self.emojisContextKeys = emojisTypes
                }
            } else {
                
            }

        }
    }
}


class EmojiTableViewCell: UITableViewCell {
    @IBOutlet var collectionview: UICollectionView!
}


class EmojiItemCell: UICollectionViewCell {
    @IBOutlet var webView: UIWebView!
    @IBOutlet var imgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //webView.scrollView.setZoomScale(2.0, animated: false)
    }
}
