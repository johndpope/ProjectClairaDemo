//
//  NewUserVC.swift
//  Claireabella
//
//  Created by Intelivita on 04/05/17.
//  Copyright © 2017 Intelivita. All rights reserved.
//

import UIKit

class NewUserVC: UIViewController {

    @IBOutlet var newUser_image: UIImageView!
    
    @IBOutlet var btnLetGo: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let image: UIImage = UIImage(named: "New_user")!
        newUser_image = UIImageView(image: image)
     
    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @IBAction func Let_GO(_ sender: UIButton) {
        
        
    }

}
