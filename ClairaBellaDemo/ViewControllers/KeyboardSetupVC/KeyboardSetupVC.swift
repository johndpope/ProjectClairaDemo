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

        keyboardInstalledView.isHidden = !cbKeybaordEnabled
        keyboardNotInstalledView.isHidden = cbKeybaordEnabled
        gifImageView.image = UIImage.gifImageWithName("allowfullaccess")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeBtn_clicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
