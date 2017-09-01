//
//  CreatedCharacterVC.swift
//  Claireabella
//
//  Created by Intelivita on 17/05/17.
//  Copyright © 2017 Intelivita. All rights reserved.
//

import UIKit

class SaveCharacterVC: UIViewController,UITextFieldDelegate {
    @IBOutlet var horizontalConstraints: [NSLayoutConstraint]?
    @IBOutlet var indicator: UIActivityIndicatorView!
    
    @IBOutlet var Character_Imageview: UIImageView!
    @IBOutlet var name_textfield: UITextField!
    @IBOutlet var Character_View: UIView!
    
    @IBOutlet weak var save_btn: UIButton!

    var isCharacterEditMode = false
    
    //this json object required for saving character.
    var character: Character!
    
    @IBOutlet var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let charHtml = character.charHtml {
            webView.loadHTMLString(charHtml, baseURL: nil)
            webView.scrollView.setZoomScale(1.1, animated: false)
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
    override func viewDidAppear(_ animated: Bool) {
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool // called when 'return' key pressed. return false to ignore.
    {
        name_textfield.resignFirstResponder()
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {    //delegate method
        name_textfield.text = ""
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
        return newLength <= 10 // Bool
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
    
    @IBAction func Btn_BackClicked() {
        if let navController = self.navigationController {
            navController.popViewController(animated: true)
        }
    }
    
    @IBAction func BtnSaved_ViewCharacter_Action(_ sender: UIButton) {
        
        func showAlert(message: String, isCharacterSaved: Bool = false) {
            let alertController = UIAlertController(title: message, message: "", preferredStyle: .alert)
            
            let OKAction = UIAlertAction(title: "OK", style: .default, handler: {
                alert -> Void in
                if isCharacterSaved {
                    self.navigationController?.popViewController(animated: true)
                }
                
            })
            alertController.addAction(OKAction)
            
            self.present(alertController, animated: true, completion: nil)

        }
         if  (name_textfield.text?.characters.count)! > 0 {
            self.saveCharacterAPICAll()
            
         } else {
            showAlert(message: "Character name is required.")

        }
       
    }
    
    
    func saveCharacterAPICAll() {
        
        func showAlert(message: String) {
            let alertController = UIAlertController(title: message, message: "", preferredStyle: .alert)
            
            let OKAction = UIAlertAction(title: "OK", style: .default, handler: {
                alert -> Void in
                    _ = self.navigationController?.popViewController(animated: true)
                
            })
            alertController.addAction(OKAction)
            
            self.present(alertController, animated: true, completion: nil)
            
        }
        
        indicator.startAnimating()

        let params = ["choices" : character.choices,
                    "saved_name": character.name,
                    "source": "ios_app",
                    "brand": "claireabella"] as [String : Any]
        APICall.shared.createNewCharacter_APICall(json: params) { (response, success) in
            self.indicator.stopAnimating()
            if success {
                showAlert(message: "Character saved successfully.")
            } else {
                showAlert(message: "Something went wrong.")
            }
        }
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

