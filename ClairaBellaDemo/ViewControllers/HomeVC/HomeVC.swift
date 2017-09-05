//
//  HomeVC.swift
//  ClairaBellaDemo
//
//  Created by Vikash Kumar on 04/09/17.
//  Copyright © 2017 Vikash Kumar. All rights reserved.
//

import UIKit

class HomeVC: ParentVC {

    override func viewDidLoad() {
        super.viewDidLoad()
    }


}

//MARK:- IBActions
extension HomeVC {
    @IBAction func btn_StartNow(_ sender: UIButton) {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "CharBuilderNavVC") as! UINavigationController
        self.present(viewController, animated: true, completion: nil)
    }

    
    @IBAction func Btn_ShopeCollection(_ sender: UIButton) {
        let url = URL(string: "http://www.toxicfox.co.uk/claireabella")!
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }

    @IBAction func Btn_ViewAllCollection(_ sender: UIButton) {
        //        let url = URL(string: "http://www.toxicfox.co.uk/claireabella/claireabella-home/claireabella-apron")!
        
        let url = URL(string: "http://www.toxicfox.co.uk/claireabella/")!
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }

    @IBAction func Btn_BagShoping_Clicked(_ sender: UIButton) {
        let url = URL(string: "http://www.toxicfox.co.uk/claireabella/claireabella-fashion-bags-simple/claireabella-jute-bags")!
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    
    @IBAction func Btn_PhoneCase_Clicked(_ sender: UIButton) {
        let url = URL(string: "http://www.toxicfox.co.uk/claireabella/claireabella-protective-cases/claireabella-protective-phone-cases")!
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    @IBAction func Btn_SuitcaseClicked(_ sender: UIButton) {
        let url = URL(string: "http://www.toxicfox.co.uk/claireabella/claireabella-suitcases")!
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    
    
    @IBAction func Btn_FashionClicked(_ sender: UIButton) {
        let url = URL(string: "http://www.toxicfox.co.uk/claireabella/claireabella-fashion")!
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }

}
