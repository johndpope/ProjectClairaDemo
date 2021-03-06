//
//  ShareCharacterVC.swift
//  ClairaBellaDemo
//
//  Created by Vikash Kumar on 21/09/17.
//  Copyright © 2017 Vikash Kumar. All rights reserved.
//

import UIKit
import FBSDKShareKit
import FBSDKLoginKit
import TwitterKit



var selectedCharForPostcard: Character?

class ShareCharacterVC: ParentVC {
    @IBOutlet var webview: UIWebView!
    @IBOutlet var collView: UICollectionView!
    @IBOutlet var indicator: IndicatorView!
    @IBOutlet var backImageView: UIImageView!
    @IBOutlet var backBtn: UIButton!
    @IBOutlet var noCharactersView: UIView!
    @IBOutlet var charListView: UIScrollView!
    @IBOutlet var tblView: UITableView!
    
    @IBOutlet var charTblHeightConstraint: NSLayoutConstraint!
    @IBOutlet var webviewHeight: NSLayoutConstraint!
    @IBOutlet var webviewWidth: NSLayoutConstraint!
    @IBOutlet var webviewCenterX: NSLayoutConstraint!
    @IBOutlet var webviewTopSpace: NSLayoutConstraint!

    var character: Character?
    
    var backgrounds = [CharBackground]()
    var charGenerator = CharacterHTMLBuilder.shared

    var comeFromHomeScreen = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collView.contentInset = UIEdgeInsetsMake(8, 8, 8, 8)
        loadBackgroundImages()
        charListView.bounces = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        noCharactersView.isHidden = !Character.myCharacters.isEmpty
        tblView.reloadData()
        setUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        character = nil
    }
    
    func setUI() {
        setWebviewFrame()
        
        if selectedCharForPostcard == nil { //user select Postcard Tab
            
            character = Character.mainCharacter

            if Character.myCharacters.isEmpty {
                noCharactersView.isHidden = false
                charListView.isHidden = true
                backBtn.isHidden = true
                collView.isHidden = true


            } else if Character.myCharacters.count == 1 {
                charListView.isHidden = true
                backBtn.isHidden = true
                collView.isHidden = false

            } else {
                charListView.isHidden = false
                backBtn.isHidden = false
                collView.isHidden = true

            }
            
            backBtn.isHidden = true
            
        } else { // user select postcard for a character.
            character = selectedCharForPostcard
            selectedCharForPostcard = nil
            noCharactersView.isHidden = true
            charListView.isHidden = true
            backBtn.isHidden = Character.myCharacters.count == 1
            collView.isHidden = false
        }
        
        if let char = character {
            CharacterHTMLBuilder.shared.buildCharHTMLWith(choices: char.choices, block: { html in
                self.webview.loadHTMLString(html, baseURL: nil)
            })
        }
        
        setTableViewHeight()
    }
    
    func setWebviewFrame() {
        webviewWidth.constant = (SCREEN_WIDTH == 320 ? 200 : 200) * widthRatio
        webviewHeight.constant = (SCREEN_WIDTH == 320 ? 210 : 200) * widthRatio
        webviewCenterX.constant = (SCREEN_WIDTH == 320 ? -40 : -20) * widthRatio
        webviewTopSpace.constant = (SCREEN_WIDTH == 320 ? -5 : 20) * widthRatio
    }
    
    func loadBackgroundImages() {
        
        var noneBack = CharBackground()
        noneBack.icon = "Background_none"
       // self.backgrounds.append(noneBack)
        
        (0...16).forEach { index in
            let iconName = "background_small\(index).jpg"
            let imgName = "background\(index).jpg"
            var back = CharBackground()
            back.icon = iconName
            back.image = imgName
            
            self.backgrounds.append(back)
            
        }
        backImageView.image = UIImage(named: (backgrounds.first?.image)!)

    }

    
    @IBAction func selectCharacter_btnClicked(_ sender: UIButton) {
        
        selectedCharForPostcard = Character.myCharacters[sender.tag]
        setUI()
    }

}

//MARK:- CollectionViewDelegate

extension ShareCharacterVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return backgrounds.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
       
        let back = backgrounds[indexPath.row]
        cell.imgView.image = UIImage(named: back.icon)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 32)/3
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let back = self.backgrounds[indexPath.row]
        backImageView.image = UIImage(named: back.image)
        character?.characterBackground = back
    }
    
}

extension ShareCharacterVC {
    @IBAction func createNewChar_btnClicked(_ sender: UIButton) {
        self.performSegue(withIdentifier: "NewCharVCSegue", sender: nil)
    }

    @IBAction func changeChar_btnClicked(_ sender: UIButton) {
        if let index = self.myCharactersTabIndex {
            self.tabBarController?.selectedIndex = index
        }
    }
    @IBAction func back_btnClicked(_ sender: UIButton) {
        if comeFromHomeScreen {
            _ = self.navigationController?.popViewController(animated: true)
        } else {
            if !Character.myCharacters.isEmpty {
                charListView.isHidden = false
                backBtn.isHidden = true
                collView.isHidden = true
            }
        }
    }
    
    @IBAction func share_btnClicekd(_ sender:UIButton) {
        self.tabBarController?.tabBar.isHidden = true

        ShareCharacterView.show(in: self.view, character: character!) { (action, image) in
            switch action {
            case .facebook:
                self.shareOnFacebook(image)
            case .twitter:
                self.shareOnTwitter(image)
            case .mail:
                self.shareViaMail(image)
            case .save:
                self.saveToPhots(image)
            case .more:
                self.moreShare(image: image)
            case .none:
                self.tabBarController?.tabBar.isHidden = false
            }
        }
    
    }
    
    
    func shareOnFacebook(_ image: UIImage) {
        
        
        func sharePhoto() {
            let photo = FBSDKSharePhoto(image: image, userGenerated: false)
            let content = FBSDKSharePhotoContent()
            content.photos = [photo!]
            
            let dialog = FBSDKShareDialog()
            dialog.shareContent = content
            dialog.fromViewController = self
            
            if UIApplication.shared.canOpenURL(URL(string: "fbauth2://")!) {
                dialog.mode = .native
            } else {
                dialog.mode = .browser
            }
            
            dialog.show()

        }
        
        sharePhoto()
    
//        let loginManager = FBSDKLoginManager()
//        loginManager.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
//            if result?.token != nil {
//                loginManager.logIn(withPublishPermissions: ["publish_actions"], from: self, handler: { (result, err) in
//                    sharePhoto()
//                })
//            }
//        }
        //FBSDKShareDialog.show(from: self, with: content, delegate: nil)
    }

    
    func shareOnTwitter(_ image: UIImage) {
        
        Twitter.sharedInstance().logIn { (session, error) in
            if let _ = session {
                let composer = TWTRComposer()
                composer.setImage(image)
                composer.show(from: self) { (result) in
                    if result == .done {
                        
                    } else {
                        
                    }
                }

            }
        }
        
    }

    func saveToPhots(_ image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.image(_:didFinishSavingWithError:contextInfo:)), nil)
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
    
    func shareViaMail(_ image: UIImage) {
        //code for copy image //previously this func was used for sending email
        let pasteBoard = UIPasteboard.general
        let imagedata = UIImagePNGRepresentation(image)
        pasteBoard.setData(imagedata!, forPasteboardType: UIPasteboardTypeListImage.object(at: 0) as! String)
        
        let ac = UIAlertController(title: "Saved!", message: "Your character image has been copied to pastboard.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)

    }
    
}


extension UIViewController {
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Claireabella", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}


//MARK:- Tableview delegate

extension ShareCharacterVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return Character.myCharacters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "characterCell") as! CharacterCell
        let char = Character.myCharacters[indexPath.row]
        cell.lblCharacterName.text = char.name
        cell.setBtnTag(tag: indexPath.row)
        
        cell.charView.characterGenerator = charGenerator
        cell.charView.character = char
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            selectedCharForPostcard = Character.myCharacters[indexPath.row]
            setUI()
    }

    func setTableViewHeight() {
        charTblHeightConstraint.constant = CGFloat(Character.myCharacters.count * 120)
    }

}
