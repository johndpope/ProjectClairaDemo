//
//  MFAViewControllerVC.swift
//  ClairaBellaDemo
//
//  Created by Vikash Kumar on 10/01/18.
//  Copyright © 2018 Vikash Kumar. All rights reserved.
//

import UIKit
import AWSCognitoIdentityProvider

class MFAViewControllerVC: ParentVC {
    @IBOutlet var txtCode: UITextField!
    @IBOutlet var errorListView: UIView!

    
    var mfaCodeCompletionSource: AWSTaskCompletionSource<NSString>?
    var destination: String?
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //IBActions
    @IBAction func textFieldEditingBegin(_ sender: UITextField) {
        let color = UIColor(colorLiteralRed: 74.0/255.0, green: 144.0/255.0, blue: 226.0/255.0, alpha: 1)
        sender.setBorder(color: color)
    }
    
    @IBAction func textFieldEditingEnd(_ sender: UITextField) {
        sender.setBorder(color: UIColor.clear)
    }

    @IBAction func verifyCode_btnClicked(_ sender: UIButton) {
        if isValidate() {
            progressHUD.show()
            
            let code = txtCode.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            //self.mfaCodeCompletionSource?.set(result: code as NSString)
            appDelegate.currentUser?.confirmSignUp(code).continueWith(executor: AWSExecutor.mainThread(), block: { (task) -> Any? in
                self.progressHUD.hide()
                if let error = task.error as? NSError {
                    self.showAlert(message: (error.userInfo["message"] as? String) ?? "")
                } else {
                    appDelegate.fetchUserDetails()
                    self.performSegue(withIdentifier: "gotoLogin", sender: nil)
                }
                
                return nil
            })
        }
    }

    @IBAction func backBtnClicked(_ sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }

    //validation method
    func isValidate()-> Bool {
        var isValid = true
        let code = txtCode.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        txtCode.setBorder(color:UIColor.clear)
        
        let errorColor = UIColor(colorLiteralRed: 150.0/255.0, green: 30.0/255.0, blue: 44.0/255.0, alpha: 0.8)
        
        if code.isEmpty {
            isValid = false
            txtCode.setBorder(color:errorColor)
        }
        errorListView.isHidden = isValid
        return isValid
    }

}

// MARK :- AWSCognitoIdentityMultiFactorAuthentication delegate

extension MFAViewControllerVC : AWSCognitoIdentityMultiFactorAuthentication {
    
    func didCompleteMultifactorAuthenticationStepWithError(_ error: Error?) {
        DispatchQueue.main.async(execute: {
            if let error = error as NSError? {
                
                let alertController = UIAlertController(title: error.userInfo["__type"] as? String,
                                                        message: error.userInfo["message"] as? String,
                                                        preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(okAction)
                
                self.present(alertController, animated: true, completion:  nil)
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        })
    }
    
    func getCode(_ authenticationInput: AWSCognitoIdentityMultifactorAuthenticationInput, mfaCodeCompletionSource: AWSTaskCompletionSource<NSString>) {
        self.mfaCodeCompletionSource = mfaCodeCompletionSource
        self.destination = authenticationInput.destination
    }
    
}

