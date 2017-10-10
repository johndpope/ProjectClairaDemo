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

class SignUpVC: UIViewController, UITextFieldDelegate {

    var nameTextField: UITextField!
    var emailTextField: UITextField!
    var passwordTextField: UITextField!
    var lastNameTextField: UITextField!
    
    @IBOutlet var btn_pressed: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.createLayout()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createLayout()
    {
        let scrollView = UIScrollView(frame :CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        //scrollView.contentSize = CGSize(width: SCREEN_WIDTH, height:SCREEN_HEIGHT+100)
        self.view.addSubview(scrollView)

        let backBtn = UIButton(type: UIButtonType.custom) as UIButton
        backBtn.frame = CGRect(x:0, y:20, width: SCREEN_HEIGHT*0.075, height: SCREEN_HEIGHT*0.075)
        backBtn.setImage(UIImage(named: "BackArrow"), for: .normal)
        backBtn.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        backBtn.addTarget(self, action: #selector(self.backClick(_:)), for: UIControlEvents.touchUpInside)
        scrollView.addSubview(backBtn)
        
        let title = UIButton(type: UIButtonType.custom) as UIButton
        title.frame = CGRect(x:SCREEN_WIDTH*0.25, y:20, width: SCREEN_WIDTH*0.50, height: SCREEN_HEIGHT*0.075)
        title.setTitle("Join ClaireaBella", for: .normal)
        //title.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        title.titleLabel?.font = UIFont(name: FONT_LIGHT , size: 16)
        title.backgroundColor = PINK_LIGHT
        scrollView.addSubview(title)
        
        let lineHeaderView = UIView(frame: CGRect(x:0,y:title.frame.origin.y+title.frame.size.height-5,width:SCREEN_WIDTH,height:1.5))
        lineHeaderView.backgroundColor = UIColor.white
        scrollView.addSubview(lineHeaderView)
        
        let fblogInBtn = UIButton(type: UIButtonType.custom) as UIButton
        fblogInBtn.frame = CGRect(x:SCREEN_WIDTH*0.05, y:SCREEN_HEIGHT*0.13, width: SCREEN_WIDTH*0.90, height: 65)
        fblogInBtn.addTarget(self, action: #selector(self.Btn_Facebook_Login(_:)), for: UIControlEvents.touchUpInside)
        fblogInBtn.setBackgroundImage(UIImage(named :"Btn_Facebook_SignUP"), for: .normal)
        scrollView.addSubview(fblogInBtn)
        
        let or = UIButton(type: UIButtonType.custom) as UIButton
        or.frame = CGRect(x:SCREEN_WIDTH*0.10, y:fblogInBtn.frame.origin.y+fblogInBtn.frame.size.height+15, width: SCREEN_WIDTH*0.80, height: 20)
        or.setTitle("Or Sign Up With Email", for: .normal)
        or.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        or.titleLabel?.font = UIFont(name: FONT_BOLD , size: 16)
        or.backgroundColor = PINK_LIGHT
        scrollView.addSubview(or)
        
        emailTextField = UITextField(frame: CGRect(x:SCREEN_WIDTH*0.05, y:or.frame.origin.y+or.frame.size.height+20, width:SCREEN_WIDTH*0.90, height:50))
        //emailTextField.placeholder = "Email Address"
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Email Address",
                                                                     attributes: [NSForegroundColorAttributeName: UIColor.black])
        emailTextField.textColor = UIColor.black
        emailTextField.textAlignment = .center
        emailTextField.autocapitalizationType = .none
        emailTextField.autocorrectionType = .no
        emailTextField.keyboardType = .emailAddress
        emailTextField.returnKeyType = .default
        emailTextField.contentVerticalAlignment = .center
        emailTextField.delegate = self
        //emailTextField.backgroundColor = UIColor.white
        emailTextField.background = UIImage(named:"Button_Back")
        scrollView.addSubview(emailTextField)
        
        nameTextField = UITextField(frame: CGRect(x:SCREEN_WIDTH*0.05, y:emailTextField.frame.origin.y+emailTextField.frame.size.height+10, width:SCREEN_WIDTH*0.90, height:50))
        //nameTextField.placeholder = "Name"
        nameTextField.attributedPlaceholder = NSAttributedString(string: "First Name",
                                                                  attributes: [NSForegroundColorAttributeName: UIColor.black])
        nameTextField.textColor = UIColor.black
        nameTextField.textAlignment = .center
        nameTextField.autocapitalizationType = .none
        nameTextField.autocorrectionType = .no
        nameTextField.keyboardType = .default
        nameTextField.returnKeyType = .default
        nameTextField.contentVerticalAlignment = .center
        nameTextField.delegate = self
        //nameTextField.backgroundColor = UIColor.white
        nameTextField.background = UIImage(named:"Button_Back")
        scrollView.addSubview(nameTextField)
        
        lastNameTextField = UITextField(frame: CGRect(x:SCREEN_WIDTH*0.05, y:nameTextField.frame.origin.y+nameTextField.frame.size.height+10, width:SCREEN_WIDTH*0.90, height:50))
        //lastNameTextField.placeholder = "Name"
        lastNameTextField.attributedPlaceholder = NSAttributedString(string: "Last Name",
                                                               attributes: [NSForegroundColorAttributeName: UIColor.black])
        lastNameTextField.textColor = UIColor.black
        lastNameTextField.textAlignment = .center
        lastNameTextField.autocapitalizationType = .none
        lastNameTextField.autocorrectionType = .no
        lastNameTextField.keyboardType = .default
        lastNameTextField.returnKeyType = .default
        lastNameTextField.contentVerticalAlignment = .center
        lastNameTextField.delegate = self
        //lastNameTextField.backgroundColor = UIColor.white
        lastNameTextField.background = UIImage(named:"Button_Back")

        scrollView.addSubview(lastNameTextField)
        
//        passwordTextField = UITextField(frame: CGRect(x:SCREEN_WIDTH*0.05, y:lastNameTextField.frame.origin.y+lastNameTextField.frame.size.height+10, width:SCREEN_WIDTH*0.90, height:50))
//        //passwordTextField.placeholder = "Password"
//        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password",
//                                                                     attributes: [NSForegroundColorAttributeName: UIColor.black])
//        passwordTextField.textColor = UIColor.black
//        passwordTextField.textAlignment = .center
//        passwordTextField.autocapitalizationType = .none
//        passwordTextField.autocorrectionType = .no
//        passwordTextField.keyboardType = .default
//        passwordTextField.returnKeyType = .default
//        passwordTextField.contentVerticalAlignment = .center
//        passwordTextField.delegate = self
//        passwordTextField.leftViewMode = .always
//        passwordTextField.isSecureTextEntry = true
//       // passwordTextField.backgroundColor = UIColor.white
//        passwordTextField.background = UIImage(named:"Button_Back")
//        scrollView.addSubview(passwordTextField)
        
        let registerBtn = UIButton(type: UIButtonType.custom) as UIButton
        registerBtn.frame = CGRect(x:SCREEN_WIDTH*0.05, y:lastNameTextField.frame.origin.y+lastNameTextField.frame.size.height+25, width: SCREEN_WIDTH*0.90, height: 50)
        registerBtn.addTarget(self, action: #selector(self.signUpBtnClick(_:)), for: UIControlEvents.touchUpInside)
        registerBtn.backgroundColor = PINK
        registerBtn.setTitle("Join", for: .normal)
        registerBtn.titleLabel?.font = UIFont(name: FONT_LIGHT , size: 18)
        registerBtn.layer.cornerRadius = 5.0
        scrollView.addSubview(registerBtn)
        
//        let line1 = UIButton(type: UIButtonType.custom) as UIButton
//        line1.frame = CGRect(x:SCREEN_WIDTH*0.07, y:registerBtn.frame.origin.y+registerBtn.frame.size.height+20, width: SCREEN_WIDTH*0.80, height: 20)
//        line1.setTitle("  Save your unique characters.", for: .normal)
//        line1.setImage(UIImage(named:"select"), for: .normal)
//        line1.contentHorizontalAlignment = .left
//        line1.isUserInteractionEnabled = false
//        line1.titleLabel?.font = UIFont.systemFont(ofSize: 14)
//        scrollView.addSubview(line1)
//        
//        let line2 = UIButton(type: UIButtonType.custom) as UIButton
//        line2.frame = CGRect(x:SCREEN_WIDTH*0.07, y:line1.frame.origin.y+line1.frame.size.height+3, width: SCREEN_WIDTH*0.80, height: 20)
//        line2.setTitle("  Create personalised emoji’s", for: .normal)
//        line2.setImage(UIImage(named:"select"), for: .normal)
//        line2.contentHorizontalAlignment = .left
//        line2.isUserInteractionEnabled = false
//        line2.titleLabel?.font = UIFont.systemFont(ofSize: 14)
//        scrollView.addSubview(line2)
//        
//        let line3 = UIButton(type: UIButtonType.custom) as UIButton
//        line3.frame = CGRect(x:SCREEN_WIDTH*0.07, y:line2.frame.origin.y+line2.frame.size.height+3, width: SCREEN_WIDTH*0.80, height: 20)
//        line3.setTitle("  Share your characters across social.", for: .normal)
//        line3.setImage(UIImage(named:"select"), for: .normal)
//        line3.contentHorizontalAlignment = .left
//        line3.titleLabel?.font = UIFont.systemFont(ofSize: 14)
//        line3.isUserInteractionEnabled = false
//        scrollView.addSubview(line3)
        
        let imgBottom = UIImageView()
        imgBottom.frame = CGRect(x: 0, y: registerBtn.frame.origin.y+registerBtn.frame.size.height+35, width: SCREEN_WIDTH, height: 150)
        imgBottom.contentMode = .scaleAspectFit
        imgBottom.image = UIImage(named: "new_charcter")
        imgBottom.backgroundColor = UIColor.clear
        
        scrollView.addSubview(imgBottom)
        
        scrollView.contentSize = CGSize(width: SCREEN_WIDTH, height:imgBottom.frame.origin.y + imgBottom.frame.size.height + 8)
    }

    func backClick(_ sender: UIButton)
    {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func signUpBtnClick(_ sender: UIButton)
    {
        let email = emailTextField.text!
        let firstname = nameTextField.text!
        let lastName = lastNameTextField.text!
        
        if email.isEmpty {return}
        if firstname.isEmpty {return}
        if lastName.isEmpty {return}
        
        let progressHUD = ProgressView(text: "Please Wait")
        self.view.addSubview(progressHUD)
        progressHUD.show()
        
        let params = ["first_name" : firstname,  "Last_name" : lastName]
        APICall.shared.signupUser_APICall(email: email, params: params) { (response,success) in
            if success {
                let result = ["first_name" : firstname,  "last_name" : lastName, "email": email]
                UserDefaults(suiteName: appGroupName)!.setValue(result, forKey: "user_details")
                //UserDefaults.standard.setValue(result, forKey: "user_details")
                //UserDefaults.standard.synchronize()
                self.btn_pressed.sendActions(for: .touchUpInside)
            } else {
                
            }
            progressHUD.hide()
        }
    }
    
    @IBAction func Btn_Facebook_Login(_ sender: UIButton) {
        
        let progressHUD = ProgressView(text: "Please Wait")
        self.view.addSubview(progressHUD)
        progressHUD.show()
        let login: FBSDKLoginManager = FBSDKLoginManager()
        // Make login and request permissions
        login.logIn(withReadPermissions: ["email", "public_profile"], from: self, handler: {(result, error) -> Void in
            
            if error != nil {
                // Handle Error
                NSLog("Process error")
                progressHUD.hide()
            } else if (result?.isCancelled)! {
                // If process is cancel
                NSLog("Cancelled")
                progressHUD.hide()
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
                        print("\(UserDefaults.standard.value(forKey: "user_details")!)")
                        UserDefaults.standard.synchronize()
                        
//                        if let viewController = UIStoryboard(name: "Storyboard", bundle: nil).instantiateViewController(withIdentifier: "NewUserVC") as? NewUserVC {
//                            progressHUD.hide()
//                            if let navigator = self.navigationController {
//                                navigator.pushViewController(viewController, animated: true)
//                            }
//                        }
                         self.btn_pressed.sendActions(for: .touchUpInside)
                        
                    }
                }
            }
        })
    }
}
