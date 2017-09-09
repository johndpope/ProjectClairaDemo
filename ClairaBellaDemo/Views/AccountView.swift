//
//  AccountView.swift
//  Claireabella
//
//  Created by Intelivita on 11/05/17.
//  Copyright © 2017 Intelivita. All rights reserved.
//

import UIKit

class AccountView: UIView {

    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        Account_page.draw_1AccountPage(frame: self.bounds, resizing: .aspectFill)
    }
    

}
