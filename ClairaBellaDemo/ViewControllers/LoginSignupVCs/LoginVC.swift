
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

class LoginVC: UIViewController, UITextFieldDelegate {

    var emailTextField: UITextField!
    var passwordTextField: UITextField!
    
    @IBOutlet var btn_clicked: UIButton!
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
        //scrollView.contentSize = CGSize(width: SCREEN_WIDTH, height:SCREEN_HEIGHT+310)
        self.view.addSubview(scrollView)
        
        let imgLogo = UIImageView()
        imgLogo.frame = CGRect(x: 0, y: (SCREEN_HEIGHT)*0.010, width: SCREEN_WIDTH, height: IS_IPHONE_6_G ? 325 : 250)
        
        imgLogo.contentMode = .scaleAspectFit
        imgLogo.image = UIImage(named: "Wellcome_Logo")
        imgLogo.backgroundColor = UIColor.clear
        scrollView.addSubview(imgLogo)
        
        let fblogInBtn = UIButton(type: UIButtonType.custom) as UIButton
        fblogInBtn.frame = CGRect(x:SCREEN_WIDTH*0.05, y:imgLogo.frame.origin.y+imgLogo.frame.size.height-74, width: SCREEN_WIDTH*0.90, height: 65)
        fblogInBtn.addTarget(self, action: #selector(self.Btn_Facebook_Login(_:)), for: UIControlEvents.touchUpInside)
        fblogInBtn.setBackgroundImage(UIImage(named :"Btn_FAcebook_SignIN"), for: .normal)
        scrollView.addSubview(fblogInBtn)
        
        
        let or = UIButton(type: UIButtonType.custom) as UIButton
        or.frame = CGRect(x:SCREEN_WIDTH*0.10, y:fblogInBtn.frame.origin.y+fblogInBtn.frame.size.height+20, width: SCREEN_WIDTH*0.80, height: 20)
        or.setTitle(" Or Sign in with Email", for: .normal)
        or.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        or.titleLabel?.font = UIFont(name: FONT_BOLD , size: 16)
        or.backgroundColor = PINK_LIGHT
        scrollView.addSubview(or)
        
        emailTextField = UITextField(frame: CGRect(x:SCREEN_WIDTH*0.05, y:or.frame.origin.y+or.frame.size.height+15, width:SCREEN_WIDTH*0.90, height:50))
       // emailTextField.placeholder = "Email Address"
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
        emailTextField.background = UIImage(named:"Button_Back")
        scrollView.addSubview(emailTextField)
        
        
        let logInBtn = UIButton(type: UIButtonType.custom) as UIButton
        logInBtn.frame = CGRect(x:SCREEN_WIDTH*0.05, y:emailTextField.frame.origin.y+emailTextField.frame.size.height+10, width: SCREEN_WIDTH*0.90, height: 50)
        logInBtn.addTarget(self, action: #selector(self.loginBtnClick(_:)), for: UIControlEvents.touchUpInside)
        logInBtn.setBackgroundImage(UIImage(named :"main_signin"), for: .normal)
        scrollView.addSubview(logInBtn)//main_signin
        
        
        let lineView_change = UIView(frame: CGRect(x:SCREEN_WIDTH*0.05,y:logInBtn.frame.origin.y+logInBtn.frame.size.height+30,width:SCREEN_WIDTH*0.90,height:1.0))
        
        lineView_change.backgroundColor = UIColor.white
        scrollView.addSubview(lineView_change)
        
        let new_to_cala = UIButton(type: UIButtonType.custom) as UIButton
        new_to_cala.frame = CGRect(x:SCREEN_WIDTH*0.10, y:lineView_change.frame.origin.y+lineView_change.frame.size.height+20, width: SCREEN_WIDTH*0.80, height: 20)
         new_to_cala.titleLabel?.font = UIFont(name: FONT_LIGHT , size: 16)
        new_to_cala.setTitle("New to ClaireaBella?", for: .normal)
        scrollView.addSubview(new_to_cala)

        
        let registerBtn = UIButton(type: UIButtonType.custom) as UIButton
        registerBtn.frame = CGRect(x:SCREEN_WIDTH*0.05, y:new_to_cala.frame.origin.y+new_to_cala.frame.size.height+20, width: SCREEN_WIDTH*0.90, height: 50)
        registerBtn.addTarget(self, action: #selector(self.signUpBtnClick(_:)), for: UIControlEvents.touchUpInside)
        registerBtn.backgroundColor = UIColor.clear
        registerBtn.setTitle("Join", for: .normal)
        registerBtn.titleLabel?.font = UIFont(name: FONT_LIGHT , size: 18)
        registerBtn.layer.cornerRadius = 5.0
        registerBtn.layer.borderWidth = 2.0
        registerBtn.layer.borderColor = UIColor.white.cgColor
        scrollView.addSubview(registerBtn)
        
        
        let imgBottom = UIImageView()
        imgBottom.frame = CGRect(x: 0, y: registerBtn.frame.origin.y+registerBtn.frame.size.height+30, width: SCREEN_WIDTH, height: 150)
        imgBottom.contentMode = .scaleAspectFit
        imgBottom.image = UIImage(named: "new_charcter")
        imgBottom.backgroundColor = UIColor.clear
        scrollView.addSubview(imgBottom)
        
        scrollView.contentSize = CGSize(width: SCREEN_WIDTH, height:imgBottom.frame.origin.y + imgBottom.frame.size.height + 15)
    }
    
    func loginBtnClick(_ sender: UIButton) {
        
    }
    
    func signUpBtnClick(_ sendr: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SignUp") as! SignUpVC
        self.navigationController?.pushViewController(vc, animated: true)
    }

    func Btn_Facebook_Login(_ sender: UIButton) {
        
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
                        UserDefaults.standard.setValue(result, forKey: "user_details")
                        UserDefaults.standard.setValue(facebookProfileUrl, forKey: "user_photoUrl")
                        print("\(UserDefaults.standard.value(forKey: "user_details")!)")
                        UserDefaults.standard.synchronize()
                        
//                        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeVC") as? HomeVC {
//                        progressHUD.hide()
//                            if let navigator = self.navigationController {
//                                navigator.pushViewController(viewController, animated: false)
//                            }
//                        }
                        self.btn_clicked.sendActions(for: .touchUpInside)
                        
                    }
                }
            }
        })
    }
}
