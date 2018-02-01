//
//  SignUpVC.swift
//  Claireabella
//
//  Created by Jay Patel on 6/16/17.
//  Copyright © 2017 Intelivita. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import AWSCognitoIdentityProvider

class SignUpVC: AuthenticationViewController, UITextFieldDelegate {

    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var lastNameTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var tblSignupForm: UITableView!
    @IBOutlet var tblHeaderView: UIView!
    @IBOutlet var btn_pressed: UIButton!
    @IBOutlet var errorListView: UIView!
    
    var pool: AWSCognitoIdentityUserPool?
    var sentTo: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.pool = appDelegate.pool

        nameTextField.setCornerRadius()
        emailTextField.setCornerRadius()
        lastNameTextField.setCornerRadius()
        passwordTextField.setCornerRadius()
        
        var hdvFrame = tblHeaderView.frame
        hdvFrame.size.height = hdvFrame.size.height * widthRatio
        tblHeaderView.frame = hdvFrame
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(nf:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(nf:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "confirmSignUpSegue" {
        }
    }
    
    //Keyboard notifications
    func keyboardWillShow(nf: Notification) {
        tblSignupForm.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 150, right: 0)
    }
    
    func keyboardWillHide(nf: Notification) {
        tblSignupForm.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    //TextField delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField.tag {
        case 1:
            nameTextField.becomeFirstResponder()
        case 2:
            lastNameTextField.becomeFirstResponder()
        case 3:
            passwordTextField.becomeFirstResponder()
        default:
            textField.resignFirstResponder()
        }
        return true
    }

    @IBAction func textFieldEditingBegin(_ sender: UITextField) {
        let color = UIColor(colorLiteralRed: 74.0/255.0, green: 144.0/255.0, blue: 226.0/255.0, alpha: 1)
        sender.setBorder(color: color)
    }
    
    @IBAction func textFieldEditingEnd(_ sender: UITextField) {
        sender.setBorder(color: UIColor.clear)
    }
    
    func isValidate()-> Bool {
        var isValid = true
        let email = emailTextField.text!.trimmedString()
        let firstname = nameTextField.text!.trimmedString()
        let lastName = lastNameTextField.text!.trimmedString()
        let password = passwordTextField.text!.trimmedString()
        
        emailTextField.setBorder(color:UIColor.clear)
        nameTextField.setBorder(color:UIColor.clear)
        lastNameTextField.setBorder(color:UIColor.clear)
        passwordTextField.setBorder(color:UIColor.clear)
        
        let errorColor = UIColor(colorLiteralRed: 150.0/255.0, green: 30.0/255.0, blue: 44.0/255.0, alpha: 0.8)

        if email.isEmpty || !email.isValidEmail(){
            isValid = false
            emailTextField.setBorder(color:errorColor)
        } 
        if firstname.isEmpty {
            isValid = false
            nameTextField.setBorder(color:errorColor)
        }
        
        if lastName.isEmpty {
            isValid = false
            lastNameTextField.setBorder(color:errorColor)
        }
        
        if password.isEmpty {
            isValid = false
            passwordTextField.setBorder(color:errorColor)
        }
        errorListView.isHidden = isValid
        return isValid
    }
    
    //IBActions
    @IBAction func backClick(_ sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func signUpBtnClick(_ sender: UIButton) {
        if !isValidate() {return}
        
        self.showHud()

        let email = emailTextField.text!.trimmedString()
        let firstname = nameTextField.text!.trimmedString()
        let lastName = lastNameTextField.text!.trimmedString()
        let password = passwordTextField.text!.trimmedString()

        let name = firstname + " " + lastName
        
        
        let params = ["first_name" : firstname,  "Last_name" : lastName, "password" : password]

//        signup(username: email, password: password, email: email, name: name, fbLogin: false) { (success) in
//            self.hideHud()
//        }
        
        signup(email: email, params: params)
    }
    
    

}

extension UITextField {
    func setBorder(_ width: CGFloat = 1.5, color: UIColor) {
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = width
    }
    
    func setCornerRadius(_ radius: CGFloat = 5) {
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }
}

extension String {
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }

}
