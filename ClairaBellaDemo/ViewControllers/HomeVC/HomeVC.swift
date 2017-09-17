//
//  HomeVC.swift
//  ClairaBellaDemo
//
//  Created by Vikash Kumar on 04/09/17.
//  Copyright © 2017 Vikash Kumar. All rights reserved.
//

import UIKit

class HomeVC: ParentVC {
    @IBOutlet var containerView: UIView!
    @IBOutlet var webView: UIWebView!
    @IBOutlet var webViewContainer: UIView!
    @IBOutlet var charCountView: UIView!
    @IBOutlet var lblCharCount: UILabel!
    @IBOutlet var createCharsView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }

    func setUI() {
        var fr = containerView.frame
        fr.size.height = 2250 * widthRatio
        containerView.frame = fr
       
        if Character.myCharacters.isEmpty {
            webViewContainer.isHidden = true
        } else {
            webViewContainer.isHidden = false
            let mainChar: Character
            if let char = Character.mainCharacter {
                mainChar = char
            } else {
                mainChar = Character.myCharacters.first!
            }
            
            lblCharCount.text = "\(Character.myCharacters.count)"
            
            CharacterHTMLBuilder.shared.buildCharHTMLWith(choices: mainChar.choices, block: { html in
                self.webView.loadHTMLString(html, baseURL: nil)
            })
        }
        
        setViews()
    }
    
    func setViews() {
        createCharsView.layer.borderWidth = 1.5
        createCharsView.layer.borderColor = UIColor.red.cgColor
        createCharsView.layer.cornerRadius = 5.0
        createCharsView.clipsToBounds = true
    }

}


//MARK:- IBActions
extension HomeVC {
    @IBAction func btn_StartNow(_ sender: UIButton) {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "CharBuilderNavVC") as! UINavigationController
        self.present(viewController, animated: true, completion: nil)
    }

    @IBAction func btn_CreateEmojisClicked(_ sender: UIButton) {
        self.tabBarController?.selectedIndex = 2
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
