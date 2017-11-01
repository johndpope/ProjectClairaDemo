
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
    @IBOutlet weak var emojiToImageGeneratorView: EmojiImageGeneratorView!
    @IBOutlet weak var loadingHudView: UIView!
    
    var filemanager = FileManager.default
    var isNewChar = false
    
    var character: Character? {
        willSet (newChar) {
            isNewChar = true
            if (character?.createdDate == newChar?.createdDate && (newChar!.editMode == false)) {
                isNewChar = false
            }
        }
        
    }
    
    var charGenerator = CharacterHTMLBuilder.shared

    //Names of the keys getting from Emoji context api.
    var emojisContextKeys = [String]() {
        didSet {
            self.characterDidChange()
        }
    }
    
    var emojis = [Emoji]()
    
    let numberOfEmojisInRow = 3
    var emojiItemHeight: CGFloat {
     return (SCREEN_WIDTH-6)/CGFloat(numberOfEmojisInRow)
    }
   
    var emojisCellHeight: CGFloat {
        let rem = emojisContextKeys.count % numberOfEmojisInRow
        let rowCount = (emojisContextKeys.count / numberOfEmojisInRow) + (rem > 0 ? 1 : 0)
        
        let cellHeight = emojiItemHeight * CGFloat(rowCount )
        return cellHeight +  CGFloat(rowCount * 2)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getEmojisContexts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
        if let char = characterForEmoji {
            character = char
            characterDidChange()

            characterForEmoji = nil
        } else  {
            if !Character.myCharacters.isEmpty {
                if let defaultChar = Character.mainCharacter {
                    character = defaultChar

                } else {
                    character = Character.myCharacters.first!
                }
                characterDidChange()

            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        characterForEmoji = nil
        //character = nil
    }
    
    func characterDidChange() {
        if self.isNewChar {
            character?.emojis.removeAll()
            tableView.reloadData()
            
            DispatchQueue.global().async {
                for type in self.emojisContextKeys {
                    let emoji = Emoji()
                    emoji.key = type
                    emoji.charHtml = ""
                    emoji.characterCreatedDate = self.character?.createdDate ?? ""
                    self.character?.emojis.append(emoji)
                }
                

                DispatchQueue.main.async {
                    self.startGenerateEmojiImages()
                }
            }
            
        }
    }
    
    //MARK: Convert emoji web to image
    func startGenerateEmojiImages() {
        if let char = self.character {
            self.emojiToImageGeneratorView.character = char
            let progressHUD = ProgressView(text: "Saving Emojis")
            
            self.emojiToImageGeneratorView.didStartBlock = {[weak self] in
                self?.loadingHudView.addSubview(progressHUD)
                self?.loadingHudView.isHidden = false
                
                progressHUD.show()
                self?.tabBarController?.tabBar.isUserInteractionEnabled = false
                self?.emojis.removeAll()

            }
            
            self.emojiToImageGeneratorView.didImageCapturedForEmojiBlock = {[weak self] emoji in
                if let weakSelf = self {
                    weakSelf.emojis.append(emoji)
                    let index = weakSelf.emojis.count-1
                    let indexPath = IndexPath(item: index, section: 0)
                    
                    if let cell = self?.tableView.cellForRow(at: IndexPath(row:1, section:0)) as? EmojiTableViewCell {
                        cell.collectionview.insertItems(at: [indexPath])
                        //cell.collectionview.scrollToItem(at: indexPath, at: .centeredVertically, animated: true)
                    } else {
                        self?.tableView.reloadData()
                    }
                }
            }
            
            self.emojiToImageGeneratorView.completionBlock = { [weak self] in
                DispatchQueue.main.async(execute: {
                    if let weakSelf = self {
                        weakSelf.emojis = weakSelf.character!.emojis
                        weakSelf.tableView.reloadData()
                        weakSelf.loadingHudView.isHidden = true
                        weakSelf.tabBarController?.tabBar.isUserInteractionEnabled = true
                        self?.character?.editMode = false
                    }
                })
            }
        }

    }

}


//MARK:- IBActions
extension EmojiesVC {
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

//MARK:- TableView DataSource and Delgate
extension EmojiesVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  1 + ((character?.emojis.count ?? 0) > 0  ? 1 : 0)
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
            return emojisCellHeight//SCREEN_HEIGHT - bannerCellHeight - 64 - 49
        }
        
    }
}

extension EmojiesVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return   emojis.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cl = cell as? EmojiItemCell {
            let emoji = emojis[indexPath.item]

            let url = filemanager.containerURL(forSecurityApplicationGroupIdentifier: appGroupName)!.appendingPathComponent(character!.createdDate + "/" + emoji.key)
            
            do  {
                let data = try Data(contentsOf: url)
                let image = UIImage(data: data)
                cl.imgView.image = image
            } catch {
                
            }

        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "emojiCell", for: indexPath) as! EmojiItemCell
            cell.imgView.isHidden = !isNewChar
            return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width-6)/CGFloat(numberOfEmojisInRow)
        return CGSize(width: width, height: width)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let emoji = emojis[indexPath.item]
      
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
    
}


//MARK:- Share option methods
extension EmojiesVC {
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


//MARK:- API calls
extension EmojiesVC {
    func getEmojisContexts() {
        APICall.shared.emojis_context_APICall { (response, success) in
            if success {
                if let json = response as? [String : Any] {
                    let emojisTypes = json.map({$0.key}).sorted(by: >)
                    print(emojisTypes)
                    
                    self.emojisContextKeys = emojisTypes
                }
            } else {
                
            }

        }
    }
}


//MARK:- Emojis Cells
class EmojiTableViewCell: UITableViewCell {
    @IBOutlet var collectionview: UICollectionView!
}


class EmojiItemCell: UICollectionViewCell, UIWebViewDelegate {
    @IBOutlet var webView: UIWebView!
    @IBOutlet var imgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //webView.delegate = self
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        imgView.isHidden = false
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        imgView.isHidden = true
    }
}
