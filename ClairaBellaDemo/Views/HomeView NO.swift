//
//  HomeView NO.swift
//  Claireabella
//
//  Created by Intelivita on 05/05/17.
//  Copyright © 2017 Intelivita. All rights reserved.
//

import UIKit

class HomeView_NO: UIView {

    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        //HomeNOCharacter.drawHomeNoCharacters()
        HomeNOCharacter.drawHomeNoCharacters(frame: self.bounds, resizing: .aspectFit)
    }
    

}
