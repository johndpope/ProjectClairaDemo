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

    override func viewDidLoad() {
        super.viewDidLoad()

        
        updateConstraints()
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
        return .lightContent
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

}
