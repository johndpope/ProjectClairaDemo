//
//  ForgotPasswordVC.swift
//  ClairaBellaDemo
//
//  Created by Vikash Kumar on 09/11/17.
//  Copyright © 2017 Vikash Kumar. All rights reserved.
//

import UIKit
import AWSCognitoIdentityProvider

class ForgotPasswordVC: ParentVC, UITextFieldDelegate {
    @IBOutlet var txtEmail: UITextField!
    @IBOutlet var errorListView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtEmail?.setCornerRadius()
        // Do any additional setup after loading the view.
    }

    //Textfield delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }


    //IBActions
    @IBAction func textFieldEditingBegin(_ sender: UITextField) {
        let color = UIColor(colorLiteralRed: 74.0/255.0, green: 144.0/255.0, blue: 226.0/255.0, alpha: 1)
        sender.setBorder(color: color)
    }
    
    @IBAction func textFieldEditingEnd(_ sender: UITextField) {
        sender.setBorder(color: UIColor.clear)
    }

    @IBAction func restPassword_clicked(_ sender: UIButton) {
        if isValidate() {
            self.showHud()
            let email = txtEmail.text!.trimmedString()

            appDelegate.pool?.getUser(email).forgotPassword().continueWith(executor: AWSExecutor.mainThread(), block: { (task) -> Any? in
                self.hideHud()
                
                if let error = task.error as? NSError {
                    self.showAlert(message: (error.userInfo["message"] as? String) ?? "")
                } else {
                    self.txtEmail.text = ""
                }
                return nil
            })
        }
    }

    @IBAction func backBtnClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    //validation method
    func isValidate()-> Bool {
        var isValid = true
        let email = txtEmail.text!.trimmedString()
        
        txtEmail.setBorder(color:UIColor.clear)
        
        let errorColor = UIColor(colorLiteralRed: 150.0/255.0, green: 30.0/255.0, blue: 44.0/255.0, alpha: 0.8)
        
        if email.isEmpty || !email.isValidEmail(){
            isValid = false
            txtEmail.setBorder(color:errorColor)
        }
        errorListView.isHidden = isValid
        return isValid
    }

}
