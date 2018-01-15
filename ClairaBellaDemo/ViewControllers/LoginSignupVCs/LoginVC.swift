
//
//  LoginVC.swift
//  Claireabella
//
//  Created by Intelivita on 08/06/17.
//  Copyright © 2017 Intelivita. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import AWSCognitoIdentityProvider

protocol LoginVCDelegate: class {
    func loginWith(email: String, password: String)
}

class LoginVC: ParentVC, UITextFieldDelegate {

    @IBOutlet var txtEmail: UITextField!
    @IBOutlet var txtPassword: UITextField!
    @IBOutlet var errorListView: UIView!
    @IBOutlet var tblLoginForm: UITableView!
    @IBOutlet var tblHeaderView: UIView?
    @IBOutlet var lblErrorMessage: UILabel!

    

    var user:AWSCognitoIdentityUser?
    
    weak var delegate: LoginVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtEmail?.setCornerRadius()
        txtPassword?.setCornerRadius()
        if let hdView = tblHeaderView {
            var hdvFrame = hdView.frame
            hdvFrame.size.height = hdvFrame.size.height * widthRatio
            hdView.frame = hdvFrame
        }
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(nf:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(nf:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.charactersLoadignFinish), name: NSNotification.Name(rawValue: "CharactersLoadingFinish"), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }


    //Keyboard notifications
    func keyboardWillShow(nf: Notification) {
        tblLoginForm.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 150, right: 0)
    }
    
    func keyboardWillHide(nf: Notification) {
        tblLoginForm.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    //validation method
    func isValidate()-> Bool {
        var isValid = true
        let email = txtEmail.text!.trimmedString()
        let password = txtPassword.text!.trimmedString()
        
        txtEmail.setBorder(color:UIColor.clear)
        txtPassword.setBorder(color:UIColor.clear)
        
        let errorColor = UIColor(colorLiteralRed: 150.0/255.0, green: 30.0/255.0, blue: 44.0/255.0, alpha: 0.8)
        
        if email.isEmpty || !email.isValidEmail(){
            isValid = false
            txtEmail.setBorder(color:errorColor)
        }
        
        if password.isEmpty {
            isValid = false
            txtPassword.setBorder(color:errorColor)
        }
        errorListView.isHidden = isValid
        return isValid
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField.tag {
        case 1:
            txtPassword.becomeFirstResponder()
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

    @IBAction func loginBtnClick(_ sender: UIButton) {
        if isValidate() {
            self.showHud()
            
            let email = txtEmail.text!.trimmedString()

            let password = txtPassword.text!.trimmedString()

            appDelegate.currentUser = appDelegate.pool?.getUser(email)
            
            appDelegate.currentUser?.getSession(email, password: password, validationData: nil).continueWith(executor: AWSExecutor.mainThread(), block: { (task) -> Any? in
                self.hideHud()
               
                if let error = task.error as? NSError {
                    self.showAlert(message: (error.userInfo["message"] as? String) ?? "")
                } else {
                    //
                    
                    let result = ["email": email, "password": password]
                    UserDefaults(suiteName: appGroupName)!.setValue(result, forKey: "user_details")
                    appDelegate.fetchUserDetails()
                    appDelegate.getCharactersFromServer()
                    self.performSegue(withIdentifier: "goToHome", sender: nil)

                }
                return nil

            })
           
            //delegate?.loginWith(email: email, password: password)
            
            
        }
        
    }
    
    @IBAction func backBtnClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    
   @IBAction func signUpBtnClick(_ sendr: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SignUp") as! SignUpVC
        self.navigationController?.pushViewController(vc, animated: true)
    }

   @IBAction func Btn_Facebook_Login(_ sender: UIButton) {
        
        self.showHud()
        let login: FBSDKLoginManager = FBSDKLoginManager()
        // Make login and request permissions
        login.logIn(withReadPermissions: ["email", "public_profile"], from: self, handler: {(result, error) -> Void in
            
            if error != nil {
                // Handle Error
                NSLog("Process error")
                self.hideHud()
            } else if (result?.isCancelled)! {
                // If process is cancel
                NSLog("Cancelled")
                self.hideHud()
            }
            else {
                // Parameters for Graph Request
                let parameters = ["fields": "email, name"]
                
                FBSDKGraphRequest(graphPath: "me", parameters: parameters).start {(connection, result, error) -> Void in
                    if error != nil {
                        NSLog(error.debugDescription)
                        return
                    }
                    
                    // Result
                    //print("Result: \(result)")
                    
                    // Handle vars
                    if let result = result as? [String:Any], let email = result["email"] as? String, let fbId = result["id"] as? String {
                        print("Email: \(email)")
                        print("fbID: \(fbId)")
                        
                        let facebookProfileUrl = "http://graph.facebook.com/\(fbId)/picture?type=large"
                        print("facebookProfileUrl: \(facebookProfileUrl)")
                      
                        UserDefaults(suiteName: appGroupName)!.setValue(result, forKey: "user_details")
                        UserDefaults.standard.setValue(facebookProfileUrl, forKey: "user_photoUrl")
//                        print("\(UserDefaults.standard.value(forKey: "user_details")!)")
                        UserDefaults.standard.synchronize()
                        
                        appDelegate.getCharactersFromServer()
                        
                    }
                }
            }
        })
    }
    
    func charactersLoadignFinish() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if Character.myCharacters.isEmpty {
            let homeVC = storyboard.instantiateViewController(withIdentifier: "mainTabVC") as! UITabBarController
            let viewController = storyboard.instantiateViewController(withIdentifier: "CharBuilderNavVC") as! UINavigationController
            self.navigationController?.present(viewController, animated: true, completion: {
                self.navigationController?.viewControllers = [homeVC]
            })
        } else {
            self.performSegue(withIdentifier: "goToHome", sender: nil)
        }

    }
}


