//
//  ShareCharacterVC.swift
//  ClairaBellaDemo
//
//  Created by Vikash Kumar on 21/09/17.
//  Copyright © 2017 Vikash Kumar. All rights reserved.
//

import UIKit
import Social
import MessageUI

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
        
        if character == nil { //user select Postcard Tab
            
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
            noCharactersView.isHidden = true
            charListView.isHidden = true
            backBtn.isHidden = false
            collView.isHidden = false
        }
        
        if let char = character {
            CharacterHTMLBuilder.shared.buildCharHTMLWith(choices: char.choices, block: { html in
                self.webview.loadHTMLString(html, baseURL: nil)
            })
        }
        
        setTableViewHeight()
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
        
        character = Character.myCharacters[sender.tag]
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
        if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeFacebook) {
            let vc = SLComposeViewController(forServiceType:SLServiceTypeFacebook)!
            vc.add(image)
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
        //code for copy image //previously this func used for sending email
        let pasteBoard = UIPasteboard.general
        let imagedata = UIImagePNGRepresentation(image)
        pasteBoard.setData(imagedata!, forPasteboardType: UIPasteboardTypeListImage.object(at: 0) as! String)
        
        let ac = UIAlertController(title: "Saved!", message: "Your character image has been copied to pastboard.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)

        //
//        if MFMailComposeViewController.canSendMail() {
//            let mail = MFMailComposeViewController()
//            mail.mailComposeDelegate = self
//            let imageData: Data = UIImagePNGRepresentation(image)!
//            mail.addAttachmentData(imageData, mimeType: "image/png", fileName: "imageName")
//            self.present(mail, animated: true, completion: nil)
//        } else {
//            showAlert(message: "Please go to settings and add your email account. ")
//        }

    }
    
}

extension ShareCharacterVC: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
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
            
            if  !char.charHtml.isEmpty {
                cell.webview.loadHTMLString(char.charHtml, baseURL: nil)
                
            } else {
                charGenerator.buildCharHTMLWith(choices: char.choices, block: { html in
                    char.charHtml = html
                    cell.webview.loadHTMLString(char.charHtml, baseURL: nil)
                })
            }
            
            return cell
            
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            character = Character.myCharacters[indexPath.row]
            setUI()
    }

    func setTableViewHeight() {
        charTblHeightConstraint.constant = CGFloat(Character.myCharacters.count * 120)
    }

}
