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
    @IBOutlet var imgCharGroup: UIImageView!
    
    @IBOutlet var createCharsView: UIView!
    @IBOutlet var createChar_titleView1: UIView!//view for character available.
    @IBOutlet var createChar_titleView2: UIView!//view for no characters.
    @IBOutlet var lblUserName: UILabel!
    @IBOutlet var createBtn_bottomSpace: NSLayoutConstraint!
    @IBOutlet weak var manageCharView: UIView!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        setInitialUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setViewWithCharacters()
    }
    
    func setInitialUI() {
        var fr = containerView.frame
        fr.size.height = 2250 * widthRatio
        containerView.frame = fr
        
    }
    
    func setViewWithCharacters() {
        createChar_titleView1.isHidden = true
        createChar_titleView2.isHidden = true

        let user_deatils = UserDefaults(suiteName: appGroupName)!.value(forKey: "user_details")as? [String:String]
        
        let name = user_deatils!["name"] ?? ""
        lblUserName.text = name

        if Character.myCharacters.isEmpty {
            webViewContainer.isHidden = true
            createChar_titleView2.isHidden = false
            createBtn_bottomSpace.constant = 15 * widthRatio
            manageCharView.isHidden = true
            imgCharGroup.isHidden = false
        } else {
            imgCharGroup.isHidden = true
            createChar_titleView1.isHidden = false
            manageCharView.isHidden = false
            webViewContainer.isHidden = false
            createBtn_bottomSpace.constant = 40 * widthRatio
            
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
            
//            CharacterHTMLBuilder.shared.buildCharHTMLWith(choices: mainChar.choices, for: .blinkingEmoji, block: { (html) in
//                self.webView.loadHTMLString(html, baseURL: nil)
//            })
        }
    }

}


//MARK:- IBActions
extension HomeVC {
    
    func goToCreateNewChar() {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "CharBuilderNavVC") as! UINavigationController
        self.present(viewController, animated: true, completion: nil)
    }
    @IBAction func btn_StartNow(_ sender: UIButton) {
        goToCreateNewChar()
    }
    
    @IBAction func btn_manageChar_clicked(_ sender: UIButton) {
        self.tabBarController?.selectedIndex = 1// My characters tab selected
    }
    
    @IBAction func btn_CreateEmojisClicked(_ sender: UIButton) {
        if Character.myCharacters.isEmpty {
            goToCreateNewChar()
        } else {
            self.tabBarController?.selectedIndex = 2 //Emojis tab selected
        }
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
