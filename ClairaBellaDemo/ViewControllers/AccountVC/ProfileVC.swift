//
//  ProfileVC.swift
//  ClairaBellaDemo
//
//  Created by Vikash Kumar on 15/11/17.
//  Copyright © 2017 Vikash Kumar. All rights reserved.
//

import UIKit
import AWSCognitoIdentityProvider

enum AWSUserAttributeKey {
    static let name = "name"
    static let birthdate = "birthdate"
    static let email = "email"
}

class ProfileVC: ParentVC {
    @IBOutlet var txtEmail: UITextField!
    @IBOutlet var txtName: UITextField!
    @IBOutlet var txtDobDay: UITextField!
    @IBOutlet var txtDobMonth: UITextField!
    @IBOutlet var txtDobYear: UITextField!
    @IBOutlet var tblView: UITableView!
    @IBOutlet var lblName: UILabel!
    
    @IBOutlet var txtOldPassword: UITextField!
    @IBOutlet var txtNewPassword: UITextField!
    @IBOutlet var txtConfirmPassword: UITextField!
    
    var fbUser: CognitoUser?

    
    var navigationItems = ["Privacy Policy", "Terms of Service", "Customer Service"]
    var isLoginWithFB = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tblView.tableFooterView = UIView()
        self.setUserInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(self.setUserInfo), name: NSNotification.Name(rawValue: "NofiticationDidFinishFetchingUserDetails"), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func setUserInfo() {
        fbUser = CognitoUser.currentUser()
        
        isLoginWithFB = AmazonClientManager.shared.isLoggedIn()
        
        if let userDetails = UserDefaults(suiteName: appGroupName)!.value(forKey: "user_details")as? [String : Any] {
            
            let email: String = (userDetails[AWSUserAttributeKey.email] as? String) ?? ""
            
            if !email.isEmpty {
                txtEmail.text = email
            } else {
                txtEmail.background = UIImage(named: "textboxBack_selected")
            }

            let name = (userDetails[AWSUserAttributeKey.name] as? String) ?? ""
            lblName.text = "Hey There, \(name)"
            
            if !name.isEmpty {
                txtName.text = name
            } else {
                txtName.background = UIImage(named: "textboxBack_selected")
            }
            
            
            let dob = (userDetails[AWSUserAttributeKey.birthdate] as? String) ?? ""
            if !dob.isEmpty && dob != "00-00-0000" {
                let dobSeparates = dob.components(separatedBy: CharacterSet(charactersIn: "-"))
                let day = dobSeparates[0]
                let month = dobSeparates[1]
                let year = dobSeparates[2]
                
                txtDobDay.text = day
                txtDobMonth.text = month
                txtDobYear.text = year
            } else {
                txtDobDay.background = UIImage(named: "textboxBack_selected")
                txtDobMonth.background =  UIImage(named: "textboxBack_selected")
                txtDobYear.background = UIImage(named: "textboxBack_selected")
            }
            
            
        }
        
    }
    
    
    
    
    //MARK:- IBAction
    
    @IBAction func logOutBtn_clicked(_ sender: UIButton) {
        UserDefaults(suiteName: appGroupName)?.setValue(nil, forKey: "user_details")
        appDelegate.currentUser?.signOut()
        AmazonClientManager.shared.logOut()
        
        let rootNavVC = appDelegate.window?.rootViewController as! UINavigationController
//        if let presentdController = rootNavVC.presentedViewController {
//            presentdController.dismiss(animated: false, completion: nil)
//        }

        self.dismiss(animated: true) {
            
            let loginStoryboard = UIStoryboard(name: "WalkThrough", bundle: nil)
            let loginVC = loginStoryboard.instantiateViewController(withIdentifier: "LoginDashboard")
            rootNavVC.viewControllers = [loginVC]
            if let presentdController = rootNavVC.presentedViewController {
                presentdController.dismiss(animated: false, completion: nil)
            }
        }
    }

    @IBAction func close_btnClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveChanges_btnClicked(_ sender: UIButton) {
       updateProfile()
    }
    
    @IBAction func changePassword_btnClicked(_ sender: UIButton) {
        changePassword()
    }
    
    
    
    //MARK:- AWS Service calls
    
    func updateProfile() {
        
        guard isValidProfileData() else {return}
        let email = txtEmail.text?.trimmedString() ?? ""
        let name = txtName.text?.trimmedString() ?? ""
        let birthdate = [txtDobDay.text!, txtDobMonth.text!, txtDobYear.text!].joined(separator: "-")
        
        self.showHud()

        if isLoginWithFB {
            fbUser?.name = name
            fbUser?.birthDate = birthdate
            fbUser?.save(completition: { [unowned self] (success) in
                self.hideHud()
                if success {
                    self.showAlert(message: "Profile updated successfully.")
                    appDelegate.fetchUserDetails()
                }
            })
            
        } else {
//            let nameAtt = AWSCognitoIdentityUserAttributeType()
//            nameAtt?.name = AWSUserAttributeKey.name
//            nameAtt?.value = name
//            
//            let birthDateAtt = AWSCognitoIdentityUserAttributeType()
//            birthDateAtt?.name = AWSUserAttributeKey.birthdate
//            birthDateAtt?.value = birthdate
//            
//            appDelegate.currentUser?.update([nameAtt!, birthDateAtt!]).continueWith(executor: AWSExecutor.mainThread(), block: { (response) -> Any? in
//                self.hideHud()
//                if let error = response.error as? NSError {
//                    self.showAlert(message: (error.userInfo["message"] as? String) ?? "Something happen wrong")
//                } else {
//                    self.showAlert(message: "Profile updated successfully.")
//                    appDelegate.fetchUserDetails()
//                }
//                
//                return nil
//            })
            
            let firstName = setUserInfo()
            let params = ["date_of_birth" : birthdate, ]
            APICall.shared.updateUser_APICall(email: email, params: params, block: { (response, success) in
                self.hideHud()
                print(response)
            })
        }
        
    }
    
    func changePassword() {
        if let cell = tblView.cellForRow(at: IndexPath(row: 0, section: 0)) as? ChangePasswordCell {
            
            let newPass = cell.newPasswordField.text?.trimmedString() ?? ""
            let currentPassword = cell.oldPasswodField.text?.trimmedString() ?? ""

            if newPass.isEmpty && currentPassword.isEmpty {
                //do nothing
            } else {
                if newPass.isEmpty {
                    showAlert(message: "Please enter new password.")
                    return
                }
                if currentPassword.isEmpty {
                    showAlert(message: "Please enter your current password.")
                    return
                }
                
                changePasswordServiceCall(newPass: newPass, currentPass: currentPassword)
                
            }
        }
        
        
    }
    
    func changePasswordServiceCall(newPass: String, currentPass: String) {
        self.showHud()
        appDelegate.currentUser?.changePassword(currentPass, proposedPassword: newPass).continueWith(executor: AWSExecutor.mainThread(), block: { (task) -> Any? in
            self.hideHud()
            if let error = task.error as? NSError {
                self.showAlert(message: (error.userInfo["message"] as? String) ?? "Something happen wrong.")
            } else {
                self.showAlert(message: "Password changed successfully.")
            }

            return nil
        })
    }
    

    func isValidProfileData()-> Bool {
        let name = txtName.text?.trimmedString() ?? ""
        let dobDay = txtDobDay.text?.trimmedString() ?? ""
        let dobMonth = txtDobMonth.text?.trimmedString() ?? ""
        let dobYear = txtDobYear.text?.trimmedString() ?? ""
        
        if name.isEmpty {
            txtName.background = UIImage(named: "textboxBack_selected")
            showAlert(message: "Please enter your name.")
            return false
        }
        
        if dobDay.isEmpty && dobMonth.isEmpty && dobYear.isEmpty {
            
        } else {
            var message = ""
            if dobDay.isEmpty {
                txtName.background = UIImage(named: "textboxBack_selected")
                message = "Please enter day for Birth Date."
            } else if dobMonth.isEmpty {
                txtDobMonth.background =  UIImage(named: "textboxBack_selected")
                message = "Please enter month for Birth Date."
            } else if dobYear.isEmpty {
                txtDobYear.background = UIImage(named: "textboxBack_selected")
                message = "Please enter year for Birth Date"
            }
            
            
            if !message.isEmpty {
                showAlert(message: message)
                return false
            }
        }
        return true
    }
    
    
    //validation method
    func isValidate()-> Bool {
        var isValid = true
        let email = txtEmail.text!.trimmedString()
        let name = txtName.text!.trimmedString()
        let dobDay = txtDobDay.text!.trimmedString()
        let dobMonth = txtDobMonth.text!.trimmedString()
        let dobYear = txtDobYear.text!.trimmedString()
        
        if email.isEmpty || !email.isValidEmail(){
            txtEmail.background = UIImage(named: "textboxBack_selected")
            isValid = false
        }
        
        if name.isEmpty {
            txtName.background = UIImage(named: "textboxBack_selected")
            isValid = false
        }
        
        if dobDay.isEmpty {
            txtDobDay.background = UIImage(named: "textboxBack_selected")
            isValid = false
        }
        
        if dobMonth.isEmpty {
            txtDobMonth.background =  UIImage(named: "textboxBack_selected")
            isValid = false
        }
        
        if dobYear.isEmpty {
            txtDobYear.background = UIImage(named: "textboxBack_selected")
            isValid = false
        }
        
        return isValid
    }

}

//MARK:- UITextFieldDelegate

extension ProfileVC : UITextFieldDelegate {
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
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let str = (textView.text + text)
        if str.characters.count <= 10 {
            return true
        }
        textView.text = str.substring(to: str.index(str.startIndex, offsetBy: 10))
        return false
    }

}


//MARK:- UITableViewDelegation

extension ProfileVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return  section == 0 ? (isLoginWithFB ? 0 : 2) : (navigationItems.count + 1)
        
        return  section == 0 ? (isLoginWithFB ? 0 : 0) : (navigationItems.count + 1)

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "changePasswordCell") as! ChangePasswordCell
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "saveChangeBtnCell") as! TableCell
                return cell

            }
            
        } else {
            if indexPath.row == 3 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "logoutCell") as! TableCell
                return cell
            }
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TableCell
            cell.lblTitle.text = navigationItems[indexPath.row]
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 {
            return
        }
        if indexPath.row == 0 {
            openUrl("http://www.toxicfox.co.uk/mobile-app-privacy-policy")
        } else if indexPath.row == 1 {
            openUrl("http://www.toxicfox.co.uk/mobile-app-terms-service")
        } else if indexPath.row == 2 {
            openUrl("http://www.toxicfox.co.uk/contacts")
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return  indexPath.row == 0 ? 250 : 70
        } else {
            if indexPath.row == 3 {
                return 100
            } else {
                return 44
            }
        }
    }
    
    func openUrl(_ urlString: String) {
        let url = URL(string: urlString)!
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }

    }
}

class ChangePasswordCell: UITableViewCell {
    @IBOutlet var newPasswordField: UITextField!
    @IBOutlet var oldPasswodField: UITextField!
    
}

