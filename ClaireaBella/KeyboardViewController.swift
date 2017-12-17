//
//  KeyboardViewController.swift
//  ClaireaBella
//
//  Created by Vikash Kumar on 26/09/17.
//  Copyright © 2017 Vikash Kumar. All rights reserved.
//

import UIKit

class KeyboardViewController: UIInputViewController {
    
    @IBOutlet var nextKeyboardButton: UIButton!
    @IBOutlet var keyboardView: KeyboardView!
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        // Add custom view sizing constraints here
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
                let expandedHeight:CGFloat = 250
        
                let heightConstraint = NSLayoutConstraint(item:self.view,
                                                          attribute: .height,
                                                          relatedBy: .equal,
                                                          toItem: nil,
                                                          attribute: .notAnAttribute,
                                                          multiplier: 0.0,
                                                          constant: expandedHeight)
                self.view.addConstraint(heightConstraint)

        keyboardView = KeyboardView.add(in: self.view)
//        CharacterHTMLBuilder.shared.loadBuildData { success in
//            
//        }
        keyboardView.btnKeyboard.addTarget(self, action: #selector(handleInputModeList(from:with:)), for: .allTouchEvents)
        keyboardView.btnGlobe.addTarget(self, action: #selector(handleInputModeList(from:with:)), for: .allTouchEvents)
        keyboardView.viewController = self
        getEmojisContexts()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("Memory warning getting")
    }
    override func textWillChange(_ textInput: UITextInput?) {
        // The app is about to change the document's contents. Perform any preparation here.
    }
    
    override func textDidChange(_ textInput: UITextInput?) {
        // The app has just changed the document's contents, the document context has been updated.
        
//        var textColor: UIColor
//        let proxy = self.textDocumentProxy
//        if proxy.keyboardAppearance == UIKeyboardAppearance.dark {
//            textColor = UIColor.white
//        } else {
//            textColor = UIColor.black
//        }
//        self.nextKeyboardButton.setTitleColor(textColor, for: [])
    }

    @IBAction func returnKeyAction(_ sender: UIButton) {
        self.inputView?.endEditing(true)
    }
    
    func openApp() {
        let instagramHooks = "claireabellaApp://"
        if let appUrl = URL(string: instagramHooks) {
            _ = openURL(url: appUrl as NSURL)
        }
    }
    
    func getCharacters() {
        APICall.shared.getSavedCharaters_APICall() { (response, success) in
            if success {
                print(response!)
                if let jsonArr = response as? [[String : Any]] {
                    print(jsonArr)
                    let charters = jsonArr.map({ (json) -> Character in
                        let choice = json["choices"] as! [String : String]
                        let character = Character()
                        character.choices = choice
                        character.createdDate = json["date_created"] as! String
                        character.name = json["saved_name"] as! String
                        if let meta = json["meta"] as? [String : Any] {
                            character.alive = meta["alive"] as! Bool
                        }
                        return character
                    })
                    
                    Character.myCharacters = charters.filter({$0.alive})
                    DispatchQueue.main.async {
                        self.keyboardView.characters = Character.myCharacters
                    }
                }
                
            } else {
                
            }
            DispatchQueue.main.async {
            self.keyboardView.indicator.stopAnimating()
            }
        }

    }
   
    
    func getEmojisContexts() {
        keyboardView.indicator.startAnimating()

        APICall.shared.emojis_context_APICall { (response, success) in
            if success {
                if let json = response as? [String : Any] {
                    let emojisTypes = json.map({$0.key}).sorted(by: >)
                    print(emojisTypes)
                   
                    self.keyboardView.emojiTypes = emojisTypes
                    self.getCharacters()
                }
            } else {
                DispatchQueue.main.async {
                    self.keyboardView.indicator.stopAnimating()
                }
            }
        }
    }
}


extension UIInputViewController {
    
    func openURL(url: NSURL) -> Bool {
        do {
            let application = try self.sharedApplication()
            return application.performSelector(inBackground: "openURL:", with: url) != nil
        }
        catch {
            return false
        }
    }
    
    func sharedApplication() throws -> UIApplication {
        var responder: UIResponder? = self
        while responder != nil {
            if let application = responder as? UIApplication {
                return application
            }
            
            responder = responder?.next
        }
        
        throw NSError(domain: "UIInputViewController+sharedApplication.swift", code: 1, userInfo: nil)
    }
    
}


// Perform custom UI setup here
//        self.nextKeyboardButton = UIButton(type: .system)
//
//        self.nextKeyboardButton.setTitle(NSLocalizedString("Next Keyboard", comment: "Title for 'Next Keyboard' button"), for: [])
//        self.nextKeyboardButton.sizeToFit()
//        self.nextKeyboardButton.translatesAutoresizingMaskIntoConstraints = false
//
//        self.nextKeyboardButton.addTarget(self, action: #selector(handleInputModeList(from:with:)), for: .allTouchEvents)
//
//        self.view.addSubview(self.nextKeyboardButton)
//
//        self.nextKeyboardButton.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
//        self.nextKeyboardButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
