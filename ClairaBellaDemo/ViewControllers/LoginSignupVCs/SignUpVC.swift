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

class SignUpVC: UIViewController, UITextFieldDelegate {

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

    let progressHUD = ProgressView(text: "Please Wait")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.pool = AWSCognitoIdentityUserPool.init(forKey: AWSCognitoUserPoolsSignInProviderKey)

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
        NotificationCenter.default.addObserver(self, selector: #selector(self.charactersLoadignFinish), name: NSNotification.Name(rawValue: "CharactersLoadingFinish"), object: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
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
        let email = emailTextField.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let firstname = nameTextField.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let lastName = lastNameTextField.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let password = passwordTextField.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
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
        
        self.view.addSubview(progressHUD)
        progressHUD.show()

        let email = emailTextField.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let firstname = nameTextField.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let lastName = lastNameTextField.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let password = passwordTextField.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)

        

        
        let emailAtt = AWSCognitoIdentityUserAttributeType()
        emailAtt?.name = "email"
        emailAtt?.value = email
        
        let nameAtt = AWSCognitoIdentityUserAttributeType()
        nameAtt?.name = "given_name"
        nameAtt?.value = firstname + " " + lastName
        
        
        let dobAtt = AWSCognitoIdentityUserAttributeType()
        dobAtt?.name = "birthdate"
        dobAtt?.value = "00-00-0000"

        
        //sign up the user
        self.pool?.signUp(email, password: password, userAttributes: [emailAtt!, nameAtt!, dobAtt!], validationData: nil).continueWith {[weak self] (task) -> Any? in
            guard let strongSelf = self else { return nil }
            DispatchQueue.main.async(execute: {
                if let error = task.error as NSError? {
                    let alertController = UIAlertController(title: error.userInfo["__type"] as? String,
                                                            message: error.userInfo["message"] as? String,
                                                            preferredStyle: .alert)
                    let retryAction = UIAlertAction(title: "Retry", style: .default, handler: nil)
                    alertController.addAction(retryAction)
                    
                    self?.present(alertController, animated: true, completion:  nil)
                } else if let result = task.result  {
                    // handle the case where user has to confirm his identity via email / SMS
                    if (result.user.confirmedStatus != AWSCognitoIdentityUserStatus.confirmed) {
                        strongSelf.sentTo = result.codeDeliveryDetails?.destination
                        strongSelf.performSegue(withIdentifier: "confirmSignUpSegue", sender:sender)
                    } else {
                        let _ = strongSelf.navigationController?.popToRootViewController(animated: true)
                    }
                }
                
            })
            return nil
        }
        
        
        
//        let params = ["first_name" : firstname,  "Last_name" : lastName, "password" : password]
//        
//        APICall.shared.signupUser_APICall(email: email, params: params) { (response,success) in
//            if success {
//                let name = firstname + " " + lastName
//                let result = ["name" : name, "email": email]
//                UserDefaults(suiteName: appGroupName)!.setValue(result, forKey: "user_details")
//                //UserDefaults.standard.setValue(result, forKey: "user_details")
//                //UserDefaults.standard.synchronize()
//                //self.btn_pressed.sendActions(for: .touchUpInside)
//                appDelegate.getCharactersFromServer()
//            } else {
//                self.progressHUD.hide()
//            }
//        }
    }
    
    @IBAction func Btn_Facebook_Login(_ sender: UIButton) {
        
        self.view.addSubview(progressHUD)
        progressHUD.show()
        let login: FBSDKLoginManager = FBSDKLoginManager()
        // Make login and request permissions
        login.logIn(withReadPermissions: ["email", "public_profile"], from: self, handler: {(result, error) -> Void in
            
            if error != nil {
                // Handle Error
                NSLog("Process error")
                self.progressHUD.hide()
            } else if (result?.isCancelled)! {
                // If process is cancel
                NSLog("Cancelled")
                self.progressHUD.hide()
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
                    print("Result: \(result)")
                    
                    // Handle vars
                    if let result = result as? [String:String],
                        let email: String = result["email"],
                        let fbId: String = result["id"] {
                        print("Email: \(email)")
                        print("fbID: \(fbId)")
                        
                        let facebookProfileUrl = "http://graph.facebook.com/\(fbId)/picture?type=large"
                        print("facebookProfileUrl: \(facebookProfileUrl)")
                       
                        UserDefaults(suiteName: appGroupName)!.setValue(result, forKey: "user_details")
                        UserDefaults.standard.setValue(facebookProfileUrl, forKey: "user_photoUrl")
                        appDelegate.getCharactersFromServer()

                         self.btn_pressed.sendActions(for: .touchUpInside)
                        
                    }
                }
            }
        })
    }
    
    func charactersLoadignFinish() {
        progressHUD.hide()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if Character.myCharacters.isEmpty {
            let homeVC = storyboard.instantiateViewController(withIdentifier: "mainTabVC") as! UITabBarController
            let viewController = storyboard.instantiateViewController(withIdentifier: "CharBuilderNavVC") as! UINavigationController
           
            self.navigationController?.present(viewController, animated: true, completion: {
                self.navigationController?.viewControllers = [homeVC]
            })
        } else {
            self.btn_pressed.sendActions(for: .touchUpInside)
        }
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
