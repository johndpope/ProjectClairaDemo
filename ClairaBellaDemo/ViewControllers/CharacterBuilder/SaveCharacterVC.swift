//
//  CreatedCharacterVC.swift
//  Claireabella
//
//  Created by Intelivita on 17/05/17.
//  Copyright © 2017 Intelivita. All rights reserved.
///

import UIKit

class SaveCharacterVC: ParentVC, UITextFieldDelegate {
    @IBOutlet var indicator: IndicatorView!
    
    @IBOutlet var Character_Imageview: UIImageView!
    @IBOutlet var name_textfield: UITextField!
    @IBOutlet var Character_View: UIView!
    @IBOutlet var lblNameCharsCount: UILabel!
    
    @IBOutlet weak var save_btn: UIButton!

    let maxCharNameLength = 12
    var isCharacterEditMode = false
    
    //this json object required for saving character.
    var character: Character!
    
    @IBOutlet var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblNameCharsCount.text = "\(maxCharNameLength)"
        
        if let charHtml = character.charHtml {
            webView.loadHTMLString(charHtml, baseURL: nil)
            webView.scrollView.setZoomScale(1.05, animated: false)
        }
        
        save_btn.isHidden = !isCharacterEditMode
        name_textfield.text = character.name
        
        self.name_textfield.delegate = self;
        let leftView = UILabel(frame: CGRect(x: CGFloat(10), y: CGFloat(0), width: CGFloat(7), height: CGFloat(26)))
        leftView.backgroundColor = UIColor.clear
        name_textfield.leftView = leftView
        name_textfield.leftViewMode = .always
        name_textfield.contentVerticalAlignment = .center
        
        name_textfield.placeholder = "Name Your Character"
        name_textfield.contentVerticalAlignment = .center
        
    }

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool // called when 'return' key pressed. return false to ignore.
    {
        name_textfield.resignFirstResponder()
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {    //delegate method
        //name_textfield.text = ""
       // right_arrowImage.isHidden = true
        save_btn.isHidden = true
    }
    
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {  //delegate method
        
        if  (name_textfield.text?.characters.count)! > 0 {
           // right_arrowImage.isHidden = false
            save_btn.isHidden = false
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.characters.count + string.characters.count - range.length
        character.name = text
        return newLength <= maxCharNameLength // Bool
    }
    
    
    func keyboardWillShow(_ notification: Notification) {
        if ((notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            let userInfo = notification.userInfo!
            let keyboardSize: CGSize = (userInfo[UIKeyboardFrameBeginUserInfoKey]! as AnyObject).cgRectValue.size
                UIView.animate(withDuration: 0.1, animations: { () -> Void in
                    self.view.frame.origin.y -= keyboardSize.height - 100
                })
        }
    }
    
    func keyboardWillHide(_ notification: Notification) {
        self.view.frame.origin.y = 0
    }
  
    func enableUserInteraction() {
        UIApplication.shared.endIgnoringInteractionEvents()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)

    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func showAlert(message: String) {
        let alertController = UIAlertController(title: message, message: "", preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: {
            alert -> Void in
            _ = self.navigationController?.dismiss(animated: true, completion: nil)
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


extension SaveCharacterVC {
    @IBAction func checkBox_btnClicked(_ sender: CheckBox) {
        sender.checked = !sender.checked
    }
    
    @IBAction func Btn_BackClicked() {
        if let navController = self.navigationController {
            navController.popViewController(animated: true)
        }
    }
    
    @IBAction func BtnSaved_ViewCharacter_Action(_ sender: UIButton) {
        
        func showAlert(message: String, isCharacterSaved: Bool = false) {
            let alertController = UIAlertController(title: message, message: "", preferredStyle: .alert)
            
            let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(OKAction)
            
            self.present(alertController, animated: true, completion: nil)
            
        }
        if  (name_textfield.text?.characters.count)! > 0 {
            isCharacterEditMode ? self.updateCharacterAPICall() : self.saveCharacterAPICAll()
            
        } else {
            showAlert(message: "Character name is required.")
            
        }
    }
    
    @IBAction func textFieldDidChangeText(_ sender: UITextField) {
        character.name = sender.text!
        save_btn.isHidden = character.name.isEmpty
        let remainingChars =  maxCharNameLength - character.name.characters.count
        lblNameCharsCount.text = "\(remainingChars)"
    }


}

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
                print(response)
                if let json = response as? [String : Any] {
                    let createdDate = json["success"] as! String
                    self.character.createdDate = createdDate
                }
                self.showAlert(message: "Character saved successfully.")
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NewCharacterAddedNotification"), object: nil, userInfo: ["NewChar" : self.character])
            } else {
                self.showAlert(message: "Something went wrong.")
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
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CharacterUpdateNotification"), object: nil, userInfo: ["updatedChar" : self.character])
                
                self.showAlert(message: "Character updated successfully.")
            } else {
                self.showAlert(message: "Something went wrong.")
            }
            
        }
        
    }

}
