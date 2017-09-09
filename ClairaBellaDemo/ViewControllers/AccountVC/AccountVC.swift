//
//  AccountVC.swift
//  Claireabella
//
//  Created by Intelivita on 05/05/17.
//  Copyright © 2017 Intelivita. All rights reserved.
//

import UIKit

class AccountVC: UIViewController {

    var datePicker : UIDatePicker = UIDatePicker()
    var datePickerContainer = UIView()
    var data: NSData?
    weak var actionToEnable : UIAlertAction?
    
    @IBOutlet var Lbl_EmailId: UILabel!
    
    @IBOutlet var lbl_mainName: UILabel!
    @IBOutlet var profile_Image: UIImageView!
    @IBOutlet var Lbl_Name: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        let user_deatils = UserDefaults.standard.value(forKey: "user_details")as? [String:String]
        
        let email: String = user_deatils!["email"]!
        let name: String = user_deatils!["name"]!
        //profile_Image.layer.borderWidth = 1
        profile_Image.layer.masksToBounds = false
        //profile_Image.layer.borderColor = UIColor.black.cgColor
        profile_Image.layer.cornerRadius = profile_Image.frame.height/2
       // profile_Image.clipsToBounds = true
        
        let profile_image = UserDefaults.standard.value(forKey: "user_photoUrl")!
        let url = NSURL(string:profile_image as! String)
        data = NSData(contentsOf:url! as URL)
        if data != nil {
            profile_Image?.image = UIImage(data:data! as Data)
        }
        lbl_mainName.text = name
        Lbl_Name.text = name
        Lbl_EmailId.text = email
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        let lineView_change = UIView(frame: CGRect(x:0,y:self.view.frame.size.height - (self.tabBarController?.tabBar.frame.size.height)!-1.5,width:SCREEN_WIDTH,height:1.5))
        
        lineView_change.backgroundColor = UIColor.gray
        self.view.addSubview(lineView_change)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    func isValidEmail(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    func textChanged(_ sender:UITextField) {
       // self.actionToEnable?.isEnabled  = (sender.text! == isValidEmail(testStr: <#T##String#>))
        if isValidEmail(testStr: sender.text!) {
            self.actionToEnable?.isEnabled = true
            
        }
    }
    func textChanged_Name(_ sender:UITextField) {
        
        self.actionToEnable?.isEnabled  = (sender.text! != nil)
        
    }
    @IBAction func Btn_EditEmailID(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Edit Email-ID", message: "", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: {
            alert -> Void in
            
            let firstTextField = alertController.textFields![0] as UITextField
           // let secondTextField = alertController.textFields![1] as UITextField
            
            //print("firstName \(firstTextField.text))
            self.Lbl_EmailId.text = firstTextField.text!
            
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: {
            (action : UIAlertAction!) -> Void in
            
        })
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter Email-ID"
            textField.addTarget(self, action: #selector(self.textChanged(_:)), for: .editingChanged)
        }
//        alertController.addTextField { (textField : UITextField!) -> Void in
//            textField.placeholder = "Enter Second Name"
//        }
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        self.actionToEnable = saveAction
        saveAction.isEnabled = false
        self.present(alertController, animated: true, completion: nil)
    }
  
    @IBAction func Btn_HomeAction(_ sender: UIButton) {
         tabBarController?.selectedIndex = 0
    }
    
    
    @IBAction func Btn_EditDateofBirth(_ sender: UIButton) {
        //Create the view
       
        
        
        
        datePickerContainer.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 240)//CGRectMake(0.0, self.view.frame.height/2, 320.0, 300.0)
        datePickerContainer.backgroundColor = UIColor.white
        
        var pickerSize : CGSize = datePicker.sizeThatFits(.zero)//datePicker.sizeThatFits(CGSizeZero)
        datePicker.frame = CGRect(x: 0, y: 20, width:pickerSize.width, height: 460)
        datePicker.setDate(NSDate() as Date, animated: true)
        datePicker.maximumDate = NSDate() as Date
        datePicker.datePickerMode = UIDatePickerMode.dateAndTime
        datePicker.addTarget(self, action: Selector("dateChangedInDate:"), for: UIControlEvents.valueChanged)
        datePickerContainer.addSubview(datePicker)
        
        var doneButton = UIButton()
        doneButton.setTitle("Done", for: UIControlState.normal)
        doneButton.setTitleColor(UIColor.blue, for: UIControlState.normal)
        doneButton.addTarget(self, action: Selector("dismissPicker:"), for: UIControlEvents.touchUpInside)
        doneButton.frame    = CGRect(x: 250.0, y: 5.0, width:70.0, height: 37.0)
        
        datePickerContainer.addSubview(doneButton)
        
        self.view.addSubview(datePickerContainer)
        
    }
    /**
     * MARK - observer to get the change in date
     */
    
    func dateChangedInDate(sender:UIDatePicker){
        
        var dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.long
        dateFormatter.timeStyle = DateFormatter.Style.none
        //objMethodInc.printvj("date selected \(datePicker.date)")
        print("date selected \(datePicker.date)")
        
    }// end dateChangedInDate
    
    /*
     * MARK - dismiss the date picker value
     */
    func dismissPicker(sender: UIButton) {
       // objMethodInc.printvj("dismiss date picker")
        print("dismiss date picker")
        datePickerContainer.removeFromSuperview()
    }// end dismissPicker
   
    @IBAction func Btn_EditName(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Edit Your Name", message: "", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: {
            alert -> Void in
            
            let firstTextField = alertController.textFields![0] as UITextField
           // let secondTextField = alertController.textFields![1] as UITextField
            
           // print("firstName \(firstTextField.text), secondName \(secondTextField.text)")
            self.Lbl_Name.text = firstTextField.text
            self.lbl_mainName.text = firstTextField.text
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: {
            (action : UIAlertAction!) -> Void in
            
        })
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter Name"
             textField.addTarget(self, action: #selector(self.textChanged_Name(_:)), for: .editingChanged)
        }
        
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        self.actionToEnable = saveAction
        saveAction.isEnabled = false
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    @IBAction func Btn_PrivacyPolicy(_ sender: UIButton) {
        let url = URL(string: "https://www.google.com")!
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }

    }
    
    
    @IBAction func Btn_TermsofService(_ sender: UIButton) {
        let url = URL(string: "https://www.yahoo.com")!
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }

    }
    
    @IBAction func Btn_CustomerService(_ sender: UIButton) {
        let url = URL(string: "https://www.gmail.com")!
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }

    }
    
    
}

