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
}
