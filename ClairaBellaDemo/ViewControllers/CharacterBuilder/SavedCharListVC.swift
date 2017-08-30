//
//  SavedCharListVC.swift
//  ClairaBellaDemo
//
//  Created by Vikash Kumar on 29/08/17.
//  Copyright © 2017 Vikash Kumar. All rights reserved.
//

import UIKit

class SavedCharListVC: UIViewController {
    @IBOutlet var tableView: UITableView!
    @IBOutlet var collView: UICollectionView!
    
    var savedChars = [Character]()
    var charGenerator: CharacterHTMLBuilder! {
        didSet {
            setCharGeneratorResultBlock()
        }
    }
    
    func setCharGeneratorResultBlock() {
        charGenerator.resultBlock = { [weak self] htmlString in
            self?.getSavedChars()
        }
        
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        charGenerator = CharacterHTMLBuilder.defaultBuilder()
    }
    

    func setUI() {
        let collviewHeight = 275 * widthRatio
        var fr = collView.frame
        fr.size.height = collviewHeight
        collView.frame = fr
    }
    
    @IBAction func createNewChar_btnClicked(_ sender: UIButton) {
        self.performSegue(withIdentifier: "NewCharVCSegue", sender: nil)
    }

    
    func getSavedChars() {
        APICall.shared.getSavedCharaters_APICall(username: "test@test.com") { (response, success) in
            if success {
                print(response!)
                if let jsonArr = response as? [[String : Any]] {
                    self.savedChars = jsonArr.map({ (json) -> Character in
                        let choice = json["choices"] as! [String : String]
                        let character = Character()
                        character.choices = choice
                        return character
                    })
                    
                    DispatchQueue.main.async {
                        self.collView.reloadData()
                    }
                }
                
            } else {
                
            }
        }
    }
    
}

extension SavedCharListVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "actionButtonCell")!
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}

extension SavedCharListVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return savedChars.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "charCell", for: indexPath) as! CharCollectionViewCell
        let character  = savedChars[indexPath.item]
        
        if let html = character.charHtml {
            cell.charHTML = html
        } else {
            charGenerator.buildCharHTMLWith(choices: character.choices, block: { html in
                cell.charHTML = html
            })
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
}

class CharCollectionViewCell: UICollectionViewCell {
    @IBOutlet var webView: UIWebView!
    
    var charHTML: String = "" {
        didSet {
            webView.loadHTMLString(charHTML, baseURL: nil)
        }
    }
}

