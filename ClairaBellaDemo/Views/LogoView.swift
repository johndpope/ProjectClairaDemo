//
//  LogoView.swift
//  Claireabella
//
//  Created by Intelivita on 17/05/17.
//  Copyright © 2017 Intelivita. All rights reserved.
//

import UIKit

class LogoView: UIView {

    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
    NewUser.drawNewUsers(frame: self.bounds, resizing: .aspectFit)
        LogoImage.drawPage1()
    }
 

}
