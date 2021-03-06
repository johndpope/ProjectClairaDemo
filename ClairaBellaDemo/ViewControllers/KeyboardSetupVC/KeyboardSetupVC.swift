//
//  KeyboardSetupVC.swift
//  ClairaBellaDemo
//
//  Created by Vikash Kumar on 14/11/17.
//  Copyright © 2017 Vikash Kumar. All rights reserved.
//

import UIKit

class KeyboardSetupVC: ParentVC {
    @IBOutlet var keyboardInstalledView: UIView!
    @IBOutlet var keyboardNotInstalledView: UIView!
    @IBOutlet var gifImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        keyboardInstalledView.isHidden = !cbKeybaordEnabled
        keyboardNotInstalledView.isHidden = cbKeybaordEnabled
        gifImageView.image = UIImage.gifImageWithName("allowfullaccess")

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeBtn_clicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        //self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func keyboard_Setting_Action(_ sender: UIButton) {
        //UIApplication.shared.open(URL(string:"App-Prefs:root=General&path=Keyboard")!, options: [:], completionHandler: nil)
        
        if let url = URL(string:UIApplicationOpenSettingsURLString) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }

}
