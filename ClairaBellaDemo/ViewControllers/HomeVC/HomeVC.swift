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
        NotificationCenter.default.addObserver(self, selector: #selector(self.charactersLoadignFinish), name: NSNotification.Name(rawValue: "CharactersLoadingFinish"), object: nil)
        
//        if Character.loadingFinish {
//            if Character.myCharacters.isEmpty {
//                self.goToCreateNewChar(animation: false)
//            }
//        }
        
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
    
    
    //MARK:- Notification handler methods
    
    func charactersLoadignFinish() {
        if Character.myCharacters.isEmpty {
            self.goToCreateNewChar()
        }
        setViewWithCharacters()
    }
    
    func setViewWithCharacters() {
        createChar_titleView1.isHidden = true
        createChar_titleView2.isHidden = true
        
        let user_deatils = UserDefaults(suiteName: appGroupName)!.value(forKey: UserAttributeKey.loggedInUserKey)as? [String:String]
        
        let name = user_deatils![UserAttributeKey.name] ?? ""
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
            
        }
        
    }
    
}


//MARK:- IBActions
extension HomeVC {
    
    func goToCreateNewChar(animation: Bool = true) {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "CharBuilderNavVC") as! UINavigationController
        self.present(viewController, animated: animation, completion: nil)
    }
    
    @IBAction func btn_StartNow(_ sender: UIButton) {
        goToCreateNewChar()
    }
    
    @IBAction func btn_manageChar_clicked(_ sender: UIButton) {
        if let index = self.myCharactersTabIndex {
            self.tabBarController?.selectedIndex = index
        }
    }
    
    @IBAction func btn_CreateEmojisClicked(_ sender: UIButton?) {
        if Character.myCharacters.isEmpty {
            goToCreateNewChar()
        } else {
            if let index = self.emojisTabIndex {
                self.tabBarController?.selectedIndex = index
            }
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
