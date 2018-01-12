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
    static let name = "given_name"
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
    
    var navigationItems = ["Privacy Policy", "Terms of Service", "Customer Service"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tblView.tableFooterView = UIView()
        self.setUserInfo()
    }
    
    
    
    func setUserInfo() {
        if let userDetails = UserDefaults(suiteName: appGroupName)!.value(forKey: "user_details")as? [String : String] {
            
            let email: String = userDetails[AWSUserAttributeKey.email] ?? ""
            
            if !email.isEmpty {
                txtEmail.text = email
            } else {
                txtEmail.background = UIImage(named: "textboxBack_selected")
            }

            let name = userDetails[AWSUserAttributeKey.name] ?? ""
            lblName.text = "Hey There, \(name)"
            
            if !name.isEmpty {
                txtName.text = name
            } else {
                txtName.background = UIImage(named: "textboxBack_selected")
            }
            
            let dob = userDetails[AWSUserAttributeKey.birthdate] ?? ""
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
    
    
    //validation method
    func isValidate()-> Bool {
        var isValid = true
        let email = txtEmail.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let name = txtName.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let dobDay = txtDobDay.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let dobMonth = txtDobMonth.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let dobYear = txtDobYear.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)

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
    
    
    //MARK:- IBAction
    
    @IBAction func logOutBtn_clicked(_ sender: UIButton) {
        UserDefaults(suiteName: appGroupName)?.setValue(nil, forKey: "user_details")
        self.dismiss(animated: true) {
            let loginStoryboard = UIStoryboard(name: "WalkThrough", bundle: nil)
            let loginVC = loginStoryboard.instantiateViewController(withIdentifier: "LoginDashboard")
            let rootNavVC = appDelegate.window?.rootViewController as! UINavigationController
            rootNavVC.viewControllers = [loginVC]
        }
    }

    @IBAction func close_btnClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveChanges_btnClicked(_ sender: UIButton) {
        let name = txtName.text ?? ""
        let birthdate = [txtDobDay.text!, txtDobMonth.text!, txtDobYear.text!].joined(separator: "-")
        
        let nameAtt = AWSCognitoIdentityUserAttributeType()
        nameAtt?.name = AWSUserAttributeKey.name
        nameAtt?.value = name
        
        let birthDateAtt = AWSCognitoIdentityUserAttributeType()
        birthDateAtt?.name = AWSUserAttributeKey.birthdate
        birthDateAtt?.value = birthdate
        
    
        
        appDelegate.currentUser?.update([nameAtt!, birthDateAtt!]).continueWith(executor: AWSExecutor.mainThread(), block: { (response) -> Any? in
            if response.error == nil {
                
            }
            return nil
        })
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
        return  section == 0 ? 1 : (navigationItems.count + 1)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "changePasswordCell") as! TableCell
            return cell
            
        } else {
            if indexPath.row == 3 {
                //logoutCell
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
            openUrl("https://google.com")
        } else if indexPath.row == 1 {
            openUrl("https://yahoo.com")
        } else if indexPath.row == 2 {
            openUrl("htttps://facebook.com")
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 330
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

