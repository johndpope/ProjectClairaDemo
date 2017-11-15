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
}

extension ProfileVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return navigationItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
    
    
    func openUrl(_ urlString: String) {
        let url = URL(string: urlString)!
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }

    }
}

