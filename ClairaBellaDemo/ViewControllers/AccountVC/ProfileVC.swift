//
//  ProfileVC.swift
//  ClairaBellaDemo
//
//  Created by Vikash Kumar on 15/11/17.
//  Copyright © 2017 Vikash Kumar. All rights reserved.
//

import UIKit

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
            
            let email: String = userDetails["email"] ?? ""
            if !email.isEmpty {
                txtEmail.text = email
            } else {
                txtEmail.background = UIImage(named: "textboxBack_selected")
            }

            let name = userDetails["name"] ?? ""
            lblName.text = "Hi, There, \(name)"
            
            if !name.isEmpty {
                txtName.text = name
            } else {
                txtName.background = UIImage(named: "textboxBack_selected")
            }
            
            let dob = userDetails["dob"] ?? ""
            if !dob.isEmpty {
                let dobSeparates = dob.components(separatedBy: CharacterSet(charactersIn: ","))
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
    
    
    @IBAction func logOutBtn_clicked(_ sender: UIButton) {
        UserDefaults(suiteName: appGroupName)?.setValue(nil, forKey: "user_details")
        let loginStoryboard = UIStoryboard(name: "WalkThrough", bundle: nil)
        let loginVC = loginStoryboard.instantiateViewController(withIdentifier: "LoginVC")
        let rootNavVC = appDelegate.window?.rootViewController as! UINavigationController
        rootNavVC.viewControllers = [loginVC]
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func close_btnClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

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

extension ProfileVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return navigationItems.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 3 {
            //logoutCell
            let cell = tableView.dequeueReusableCell(withIdentifier: "logoutCell") as! TableCell
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TableCell
        cell.lblTitle.text = navigationItems[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 {
            openUrl("https://google.com")
        } else if indexPath.row == 1 {
            openUrl("https://yahoo.com")
        } else if indexPath.row == 2 {
            openUrl("htttps://facebook.com")
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 3 {
            return 100
        } else {
            return 44
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

