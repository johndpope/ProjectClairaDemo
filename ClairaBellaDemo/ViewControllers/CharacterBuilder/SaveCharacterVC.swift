//
//  CreatedCharacterVC.swift
//  Claireabella
//
//  Created by Intelivita on 17/05/17.
//  Copyright © 2017 Intelivita. All rights reserved.
///

import UIKit

class SaveCharacterVC: ParentVC {
    @IBOutlet var indicator: IndicatorView!
    
    @IBOutlet var Character_Imageview: UIImageView!
    @IBOutlet var name_textfield: UITextField!
    @IBOutlet var Character_View: UIView!
    @IBOutlet var lblNameCharsCount: UILabel!
    @IBOutlet var checkbox: UIButton!
    @IBOutlet var tblHeaderView: UIView?
    @IBOutlet var errorView: UIView!
    @IBOutlet weak var save_btn: UIButton!
    @IBOutlet var mainCharInfoView: UIView!
    @IBOutlet var mainCharInfoViewTopConstraint: NSLayoutConstraint!
    
    let maxCharNameLength = 12
    var isCharacterEditMode = false
    
    //this json object required for saving character.
    var character: Character!
    
    @IBOutlet var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblNameCharsCount?.text = "\(maxCharNameLength)"
        
        //checkbox should be checked if user haven't any saved Character.
        checkbox.isSelected = Character.myCharacters.isEmpty
        
        //user should not be able to unchecked checkbox if this is his/her first character.
        checkbox.isUserInteractionEnabled = !Character.myCharacters.isEmpty
        
        if !character.charHtml.isEmpty {
            webView.loadHTMLString(character.charHtml, baseURL: nil)
            webView.scrollView.setZoomScale(1.05, animated: false)
        }
        
        self.setUI()
    }

    func setUI() {
       // save_btn.isHidden = !isCharacterEditMode
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
        
        let errorColor = UIColor(colorLiteralRed: 150.0/255.0, green: 30.0/255.0, blue: 44.0/255.0, alpha: 0.8)
        
        if charName.isEmpty {
            isValid = false
            name_textfield.background = UIImage(named: "textboxBack_selected")
        }
        errorView.isHidden = isValid
        return isValid
    }

//    func keyboardWillShow(_ notification: Notification) {
//        UIView.animate(withDuration: 0.1, animations: { () -> Void in
//            self.view.frame.origin.y = -150
//        })
//    }
//    
//    func keyboardWillHide(_ notification: Notification) {
//        self.view.frame.origin.y = 0
//    }
  
    func enableUserInteraction() {
        UIApplication.shared.endIgnoringInteractionEvents()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)

    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
//        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
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

}

//MARK:- IBActions
extension SaveCharacterVC {
    @IBAction func checkBox_btnClicked(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func Btn_BackClicked() {
        if let navController = self.navigationController {
            navController.popViewController(animated: true)
        }
    }
    
    @IBAction func BtnSaved_ViewCharacter_Action(_ sender: UIButton) {
        
        if  isValidate() {
            isCharacterEditMode ? self.updateCharacterAPICall() : self.saveCharacterAPICAll()
            
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
    
    @IBAction func createEmoji_btnClicked(_ sender: UIButton) {
        self.navigationController?.presentingViewController?.tabBarController?.selectedIndex = 2
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func postcard_btnClicked(_ sender: UIButton) {
        self.navigationController?.presentingViewController?.tabBarController?.selectedIndex = 1
        self.navigationController?.dismiss(animated: true, completion: nil)
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
    
    func saveCharacterAPICAll() {
        indicator.startAnimating()
    
        let params = ["choices" : character.choices,
                      "saved_name": character.name,
                      "source": "ios_app",
                      "brand": "claireabella"] as [String : Any]
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

                self.showAlertMessage(message: "Character saved successfully.")
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NewCharacterAddedNotification"), object: nil, userInfo: ["NewChar" : self.character])
               
                
            } else {
                self.showAlertMessage(message: "Something went wrong.")
            }
        }
    }
    
    
    func updateCharacterAPICall() {
        indicator.startAnimating()
        
        let params = ["choices" : character.choices,
                      "saved_name": character.name,
                      "default": true,
                      ] as [String : Any]
        
        APICall.shared.updateCharacter_APICall(params: params, createdDate: character.createdDate) { (json, success) in
            self.indicator.stopAnimating()
            if success {//CharacterUpdateNotification
                if self.checkbox.isSelected {
                    UserDefaults.standard.set(self.character.createdDate, forKey: "MainCharacter")
                }
                
                deleteCharacterEmojisFromLocal(char: self.character)
                self.character.editMode = true //used for generating emojis
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CharacterUpdateNotification"), object: nil, userInfo: ["updatedChar" : self.character])
                self.generateCharacterImage()
                self.showAlertMessage(message: "Character updated successfully.")
                

            } else {
                self.showAlertMessage(message: "Something went wrong.")
            }
            
        }
        
    }

    
    func generateCharacterImage() {
        let renderer = UIGraphicsImageRenderer(size: Character_View.bounds.size)
        let image = renderer.image { ctx in
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

