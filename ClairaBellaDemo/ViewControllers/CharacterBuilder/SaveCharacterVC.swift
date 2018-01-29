//
//  CreatedCharacterVC.swift
//  Claireabella
//
///

import UIKit
import GTProgressBar



class SaveCharacterVC: ParentVC {
    @IBOutlet var indicator: IndicatorView!
    
    @IBOutlet var Character_Imageview: UIImageView!
    @IBOutlet var name_textfield: UITextField!
    @IBOutlet var Character_View: UIView!
    @IBOutlet var lblNameCharsCount: UILabel!
    @IBOutlet var checkbox: UIButton!
    @IBOutlet var tblHeaderView: UIView?
    @IBOutlet var errorView: UIView!
    @IBOutlet var save_btn: UIButton!
    @IBOutlet var mainCharInfoView: UIView!
    @IBOutlet var mainCharInfoViewTopConstraint: NSLayoutConstraint!
    
    @IBOutlet var loadignContainerView: SaveCharacterLoadingView!
    @IBOutlet weak var emojiToImageGeneratorView: EmojiImageGeneratorView!

    @IBOutlet var webView: UIWebView!
    @IBOutlet var webView2: UIWebView! //used in saved Character view

    @IBOutlet var savedCharacterView: UIView!
    
    let maxCharNameLength = 12
    var isCharacterEditMode = false
    
    //this json object required for saving character.
    var character: Character!
    
    var saveCharOperationDone = false
    var needsToUpdateEmojis = false
    
    enum NavigationChoice {
        case none, emoji, postcard, characters
    }
    
    var navigationChoice = NavigationChoice.none
    
    
    var emojisContextKeys = [String]() {
        didSet {
            //self.characterDidChange()
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadignContainerView.isHidden = true
        emojiToImageGeneratorView.isHidden = true
        savedCharacterView.isHidden = true
        
        lblNameCharsCount?.text = "\(maxCharNameLength)"
        
        //checkbox should be checked if user haven't any saved Character.
        checkbox.isSelected = Character.myCharacters.isEmpty
        
        //user should not be able to unchecked checkbox if this is his/her first character.
        checkbox.isUserInteractionEnabled = !Character.myCharacters.isEmpty
        
        if !character.charHtml.isEmpty {
            webView.loadHTMLString(character.charHtml, baseURL: nil)
            //webView.scrollView.setZoomScale(1.05, animated: false)
        }
        
        self.setUI()
        self.getEmojisContexts()
    }
    
    func setUI() {
        save_btn.isHidden = true//!isCharacterEditMode
        mainCharInfoView.isHidden = true
        name_textfield.text = character.name
        
        if let hdView = tblHeaderView {
            var hdvFrame = hdView.frame
            hdvFrame.size.height = hdvFrame.size.height * widthRatio
            hdView.frame = hdvFrame
        }
        
        
    }
    
    func isValidate()-> Bool {
        var isValid = true
        let charName = name_textfield.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        self.character.name = charName
        name_textfield.setBorder(color:UIColor.clear)
        
        if charName.isEmpty {
            isValid = false
            name_textfield.background = UIImage(named: "textboxBack_selected")
        }
        errorView.isHidden = isValid
        return isValid
    }
    
    
    func enableUserInteraction() {
        UIApplication.shared.endIgnoringInteractionEvents()
    }
    
    
    func showAlertMessage(message: String) {
        let alertController = UIAlertController(title: message, message: "", preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: {
            alert -> Void in
            //_ = self.navigationController?.dismiss(animated: true, completion: nil)
        })
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func getCurrentTimeStampWOMiliseconds(dateToConvert: NSDate) -> String {
        let objDateformat: DateFormatter = DateFormatter()
        objDateformat.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let strTime: String = objDateformat.string(from: dateToConvert as Date)
        let objUTCDate: NSDate = objDateformat.date(from: strTime)! as NSDate
        let milliseconds: Int64 = Int64(objUTCDate.timeIntervalSince1970)
        let strTimeStamp: String = "\(milliseconds)"
        return strTimeStamp
    }
    
    
    
    
    //MARK: Convert emoji HTML to image
    
    func startGenerateEmojiImages() {
        
        if let char = self.character {
            //let progressHUD = ProgressView(text: "Saving Emojis")
            self.emojiToImageGeneratorView.isHidden = false
            self.emojiToImageGeneratorView.didStartBlock = {[weak self] in
                
            }
            
            var count = 0.0
            let emojiCountsForDownload = Emoji.isNonPersnolizedEmojiDownloaded() ? self.emojisContextKeys.count-Emoji.nonPersnolizedEmojiCounts : emojisContextKeys.count
            
            self.emojiToImageGeneratorView.didImageCapturedForEmojiBlock = {[weak self] emoji in
                if let weakSelf = self {
                    count += 1
                    let progressValue = weakSelf.emojisContextKeys.count > 0 ? CGFloat(count/Double(emojiCountsForDownload)) : 0
                    
                    self?.loadignContainerView.progress = Double(progressValue)
                }
            }
            
            self.emojiToImageGeneratorView.completionBlock = { [weak self] in
                DispatchQueue.main.async(execute: {
                    if let weakSelf = self {
                        self?.loadignContainerView.progress = 1
                        weakSelf.loadignContainerView.isHidden = true
                        weakSelf.emojiToImageGeneratorView.isHidden = true
                        weakSelf.showSavedCharacterView()
                        weakSelf.hideHud()

                    }
                })
            }
            
            
            self.emojiToImageGeneratorView.character = char
            
        }
        
    }

    func showSavedCharacterView() {
        webView2.loadHTMLString(character.charHtml, baseURL: nil)
        savedCharacterView.isHidden = false
    }
}

//MARK:- IBActions
extension SaveCharacterVC {
    @IBAction func checkBox_btnClicked(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func Btn_BackClicked() {
        if saveCharOperationDone {
            self.navigationController?.dismiss(animated: true, completion: nil)
        } else {
            if let navController = self.navigationController {
                navController.popViewController(animated: true)
            }
        }
    }
    
    @IBAction func saveCharacter_btnClicked(_ sender: UIButton?) {
        
        if !saveCharOperationDone {
            navigationChoice = .none
            callSaveAPI()
        }
        
    }
    
    @IBAction func textFieldDidChangeText(_ sender: UITextField) {
        character.name = sender.text!
        save_btn.isHidden = character.name.isEmpty
        let remainingChars =  maxCharNameLength - character.name.characters.count
        lblNameCharsCount.text = "\(remainingChars)"
    }
    
    
    @IBAction func whatIsThis_btnCliked(_ sender: UIButton) {
        let senderRect = self.view.convert(sender.bounds, from: sender)
        mainCharInfoViewTopConstraint.constant = senderRect.origin.y - 80
        mainCharInfoView.isHidden = !mainCharInfoView.isHidden
        
    }
    
    @IBAction func createEmoji_btnClicked(_ sender: UIButton?) {
        navigationChoice = .emoji
        userSelectedCharForEmoji = self.character
        appDelegate.mainTabbarController?.selectedIndex = 2

        self.navigationController?.dismiss(animated: false) {
        }

    }
    
    @IBAction func postcard_btnClicked(_ sender: UIButton?) {
       
        navigationChoice = .postcard
        selectedCharForPostcard = character
        appDelegate.mainTabbarController?.selectedIndex = 1

        self.navigationController?.dismiss(animated: false) {
        }

    }
    
    @IBAction func viewCharacters_btnClicked(_ sender: UIButton?) {
        navigationChoice = .characters
        appDelegate.mainTabbarController?.selectedIndex = 0

        self.navigationController?.dismiss(animated: false) {
        }

    }
    
}

extension SaveCharacterVC : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //print("begin")
        textField.background = UIImage(named: "textboxBack_selected")
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.background = UIImage(named: "textboxBack")
    }
}


//MARK:- API calls
extension SaveCharacterVC {
    
    func callSaveAPI() {
        if isValidate() {
            loadignContainerView.isHidden = false
            isCharacterEditMode ? updateCharacterAPICall() : saveCharacterAPICAll()
        }
    }
    
    func saveCharacterAPICAll() {
        
        let params = ["choices" : character.choices,
                      "saved_name": character.name,
                      "default" : checkbox.isSelected,
                      "source": "ios_app",
                      "brand": "claireabella"] as [String : Any]
        print("Request params :=====>>>>   \n\(params)")
       
        APICall.shared.createNewCharacter_APICall(json: params) { (response, success) in
            self.indicator.stopAnimating()
            if success {
                if let json = response as? [String : Any] {
                    let createdDate = json["success"] as! String
                    self.character.createdDate = createdDate
                    Character.myCharacters.append(self.character)
                    
                    if self.checkbox.isSelected {
                        UserDefaults.standard.set(createdDate, forKey: "MainCharacter")
                    }
                }
                self.generateCharacterImage()
                
                self.setUserNavigationChoice()
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NewCharacterAddedNotification"), object: nil, userInfo: ["NewChar" : self.character])
                
                self.saveCharOperationDone = true
                self.startGenerateEmojiImages()

                //self.navigationController?.dismiss(animated: true, completion: nil)
            } else {
                self.showAlertMessage(message: "Something went wrong.")
                self.loadignContainerView.isHidden = true
            }
        }
    }
    
    
    func updateCharacterAPICall() {
        
        let params = ["choices" : character.choices,
                      "saved_name": character.name,
                      "default": checkbox.isSelected,
                      ] as [String : Any]
        APICall.shared.updateCharacter_APICall(params: params, createdDate: character.createdDate) { (json, success) in
            self.indicator.stopAnimating()
            if success {//CharacterUpdateNotification
                if self.checkbox.isSelected {
                    UserDefaults.standard.set(self.character.createdDate, forKey: "MainCharacter")
                }
                
                if self.needsToUpdateEmojis {
                    deleteCharacterEmojisFromLocal(char: self.character)
                }
                
                self.character.editMode = true //used for generating emojis
                
                self.setUserNavigationChoice()

                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CharacterUpdateNotification"), object: nil, userInfo: ["updatedChar" : self.character])
                
                self.generateCharacterImage()
                self.saveCharOperationDone = true
                
                self.startGenerateEmojiImages()
                
                //self.navigationController?.dismiss(animated: true, completion: nil)

            } else {
                self.showAlertMessage(message: "Something went wrong.")
                self.loadignContainerView.isHidden = true
            }
        }
        
    }
    
    
    func getEmojisContexts() {
        
        APICall.shared.emojis_context_APICall { (response, success) in
            if success {
                if let json = response as? [String : Any] {
                    let emojisTypes = json.map({$0.key}).sorted(by: >)
                    print(emojisTypes)
                    
                    self.emojisContextKeys = emojisTypes
                    
                    for type in self.emojisContextKeys {
                        let emoji = Emoji()
                        emoji.key = type
                        emoji.charHtml = ""
                        emoji.characterCreatedDate = self.character?.createdDate ?? ""
                        self.character?.emojis.append(emoji)
                    }

                }
            } else {
                
            }
            
        }
    }

    
    func generateCharacterImage() {
        let renderer = UIGraphicsImageRenderer(size: Character_View.bounds.size)
        let image = renderer.image { ctx in
            Character_View.backgroundColor = UIColor(colorLiteralRed: 0.96, green: 0.82, blue: 0.92, alpha: 1)
            Character_View.drawHierarchy(in: Character_View.bounds, afterScreenUpdates: true)
        }
        let filemanager = FileManager.default
        let directoryURl = filemanager.containerURL(forSecurityApplicationGroupIdentifier: appGroupName)!.appendingPathComponent( self.character.createdDate)
        
        let direcotryPath = directoryURl.path
        let filePath = direcotryPath + "/" + self.character.createdDate
        if !filemanager.fileExists(atPath: direcotryPath) {
            do {
                try filemanager.createDirectory(atPath: direcotryPath, withIntermediateDirectories: true, attributes: nil)
            } catch {
                //
            }
        }
        do {
            try UIImageJPEGRepresentation(image, 1.0)!.write(to: URL(fileURLWithPath: filePath))
            
        } catch {
            //
        }
        Character_View.backgroundColor = UIColor.clear
        
    }
    
    
    //navigation with user choice
    
    func setUserNavigationChoice() {
        if self.navigationChoice == .emoji {
            userSelectedCharForEmoji = self.character
        } else if self.navigationChoice == .postcard {
            selectedCharForPostcard = character
        } else {
        }
    }
}


//Delete saved character's emoji images from local folder.
func deleteCharacterEmojisFromLocal(char: Character) {
    let manager = FileManager.default
    let directoryURl = manager.containerURL(forSecurityApplicationGroupIdentifier: appGroupName)!.appendingPathComponent( char.createdDate)
    
    let direcotryPath = directoryURl.path
    
    if manager.fileExists(atPath: direcotryPath) {
        do {
            try manager.removeItem(atPath: direcotryPath)
        } catch let error {
            print("Deleting directory Error: \(error.localizedDescription)")
        }
    }
}


class SaveCharacterLoadingView: UIView {
    @IBOutlet var barImageView: UIImageView!
    @IBOutlet var progressImageview: UIImageView!
    
    @IBOutlet var advrtImageView: UIImageView!
    @IBOutlet var advrtTitleLabel: UILabel!
    @IBOutlet var advrtDetailLabel: UILabel!
    
    @IBOutlet var progressImgViewWidth: NSLayoutConstraint!
    
    var progressBarWidth:Double = 230
    
    var progress: Double = 0.0 {
        didSet {
            setAdvrtInfo()
            setProgressValue(progress)
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setAdvrtInfo()
    }
    
    func setProgressValue(_ progress: Double) {
        
        let width = progress * progressBarWidth
        UIView.animate(withDuration: 0.25, animations: {() -> Void in
            
            self.progressImgViewWidth.constant = CGFloat(width)
            self.layoutIfNeeded()
            
            }, completion: {(_ finished: Bool) -> Void in
        })
    }
    
    func setAdvrtInfo() {
        if progress > 0.75 {
            advrtImageView.image = #imageLiteral(resourceName: "animImage4")
            advrtTitleLabel.text = "Celebrity Gifts"
            advrtDetailLabel.text = "Shop your characters across \ntreding collections."
            
        } else if progress > 0.50 {
            advrtImageView.image = #imageLiteral(resourceName: "animImage3")
            advrtTitleLabel.text = "Fun Postcards"
            advrtDetailLabel.text = "Go fom New York to the catwalk \nwith fun backgrounds."

        } else if progress > 0.25 {
            advrtImageView.image = #imageLiteral(resourceName: "animImage2")
            advrtTitleLabel.text = "ClaireaBella Keyboard"
            advrtDetailLabel.text = "Share your emoji's wherever you chat."

        } else {
            advrtImageView.image = #imageLiteral(resourceName: "animImage1")
            advrtTitleLabel.text = "Create Your Friends"
            advrtDetailLabel.text = "Create and save multiple characters"

        }
    }
}
