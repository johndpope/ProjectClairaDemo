//
//  SetupKeyBoardVC.swift
//  Claireabella
//
//  Created by Intelivita on 11/05/17.
//  Copyright © 2017 Intelivita. All rights reserved.
//

import UIKit

class SetupKeyBoardVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func Btn_BackClicked()
    {
        for vc: UIViewController in (navigationController?.viewControllers)! {
            if (vc is EmojiesVC) {
                navigationController?.popToViewController(vc, animated: true)
            }
        }

    }

    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
      
    }
    override func viewWillDisappear(_ animated: Bool){
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
        
    }

    @IBAction func Keyboard_Setting_Action(_ sender: UIButton) {
        
       UIApplication.shared.openURL(URL(string:"App-Prefs:root=General&path=Keyboard")!)
       
    }

}
