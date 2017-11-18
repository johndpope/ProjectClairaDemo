//
//  ParentVC.swift
//  ClairaBellaDemo
//
//  Created by Vikash Kumar on 05/09/17.
//  Copyright © 2017 Vikash Kumar. All rights reserved.
//

import UIKit

let widthRatio = UIScreen.main.bounds.width/375

class ParentVC: UIViewController {
    @IBOutlet var horizontalConstraints: [NSLayoutConstraint]?
    @IBOutlet var btnKeyboard: UIButton!
    @IBOutlet var btnProfile: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setKeyboardAndProfileBtn()
    }
    
    var cbKeybaordEnabled: Bool {
        if let keboards = UserDefaults.standard.object(forKey: "AppleKeyboards") as? [String] {
            guard keboards.contains("com.unitygames.Claireabella.ClaireaBella") else {return false}
            return true
        }
            return false
    }
    
    func updateConstraints() {
        if let horizontalConstraints = horizontalConstraints {
            for constraint in horizontalConstraints {
                let v1 = constraint.constant
                let v2 = v1 * widthRatio
                constraint.constant = v2
            }
        }
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    
    func setKeyboardAndProfileBtn() {
        btnKeyboard?.isSelected = cbKeybaordEnabled
        //btnProfile?.isSelected = true
    }
    
    //MARK:- Tabbar controller's index
    var myCharactersTabIndex: Int? {
        guard let tabControllers = self.tabBarController?.viewControllers else {return nil}
        for (index,tabVC) in tabControllers.enumerated()  {
            if tabVC.restorationIdentifier! == "MyCharactersVC" {
                return index
            }
        }
        return nil
    }
    
    var postcardsTabIndex: Int? {
        guard let tabControllers = self.tabBarController?.viewControllers else {return nil}
        for (index,tabVC) in tabControllers.enumerated()  {
            if tabVC.restorationIdentifier! == "PostcardsVC" {
                return index
            }
        }
        return nil
    }

    var emojisTabIndex: Int? {
        guard let tabControllers = self.tabBarController?.viewControllers else {return nil}
        for (index,tabVC) in tabControllers.enumerated()  {
            if tabVC.restorationIdentifier! == "EmojisVC" {
                return index
            }
        }
        return nil
    }
    var shopTabIndex: Int? {
        guard let tabControllers = self.tabBarController?.viewControllers else {return nil}
        for (index,tabVC) in tabControllers.enumerated()  {
            if tabVC.restorationIdentifier! == "ShopVC" {
                return index
            }
        }
        return nil
    }

    
    @IBAction func keyboardBtn_clicked(_ sender: UIButton) {
        let kbSetupVC = self.storyboard!.instantiateViewController(withIdentifier: "keyboardSetupVC")
        kbSetupVC.modalPresentationStyle = .overCurrentContext
        if let tabbarVC = self.tabBarController {
            tabbarVC.present(kbSetupVC, animated: true, completion: nil)
            //tabbarVC.navigationController?.pushViewController(kbSetupVC, animated: true)
        } else {
            self.present(kbSetupVC, animated: true, completion: nil)

            //self.navigationController?.pushViewController(kbSetupVC, animated: true)
        }
    }
    
    @IBAction func profileBtn_clicked(_ sender: UIButton) {
        //ProfileVC
        let profileVC = self.storyboard!.instantiateViewController(withIdentifier: "ProfileVC")
        self.tabBarController?.present(profileVC, animated: true, completion: nil)
    }
}
