//
//  LoadingView.swift
//  Claireabella
//
//  Created by Intelivita on 04/05/17.
//  Copyright © 2017 Intelivita. All rights reserved.
//

import UIKit

class LoadingView: UIView {

    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect)
    {
        //Loading1.drawAnimatedLoadingScreen1()
        Loading1.drawAnimatedLoadingScreen1(frame: self.bounds, resizing: .aspectFit)
    }
 

}
