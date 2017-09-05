
//
//  EmojiesVC.swift
//  Claireabella
//
//  Created by Intelivita on 05/05/17.
//  Copyright © 2017 Intelivita. All rights reserved.
//

import UIKit

class EmojiesVC: ParentVC {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var emoji_uiimage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
    }
    
    
    func setUI() {
        var fr = containerView.frame
        fr.size.height = 726 * widthRatio
        containerView.frame = fr
    }

    @IBAction func Btn_HomeAct(_ sender: UIBarButtonItem) {
        tabBarController?.selectedIndex = 0
    }
   
    @IBAction func Btn_SetupNowAction(_ sender: UIButton) {
       self.performSegue(withIdentifier: "KeyBoardSegue", sender: nil)

    }
    
    @IBAction func Create_CharacterAction(_ sender: UIButton) {
        tabBarController?.selectedIndex = 1
    }
    
    
    @IBAction func Btn_ShareEmojiAction(_ sender: UIButton) {
//        if let vc3 = self.storyboard?.instantiateViewController(withIdentifier: "ShareVC") as? ShareVC {
//            let appDelegate = UIApplication.shared.delegate as! AppDelegate
//            appDelegate.window?.rootViewController!.present(vc3, animated: true, completion: nil)
//        }
        let VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ShareVC")
        VC.modalPresentationStyle = .overCurrentContext
        self.present(VC, animated: false, completion: nil)
        
    }
    
}
