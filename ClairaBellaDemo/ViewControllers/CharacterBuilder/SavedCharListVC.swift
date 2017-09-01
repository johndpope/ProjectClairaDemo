//
//  SavedCharListVC.swift
//  ClairaBellaDemo
//
//  Created by Vikash Kumar on 29/08/17.
//  Copyright © 2017 Vikash Kumar. All rights reserved.
//

import UIKit
import iCarousel

class SavedCharListVC: UIViewController {
    @IBOutlet var tableView: UITableView!
    @IBOutlet var carouselView: iCarousel!
    
    @IBOutlet var collView: UICollectionView!
    @IBOutlet var horizontalConstraints: [NSLayoutConstraint]?
   
    var savedChars = [Character]()
    var charGenerator: CharacterHTMLBuilder! {
        didSet {
            setCharGeneratorResultBlock()
        }
    }
    
    var currentCharIndex = 0
    
    func setCharGeneratorResultBlock() {
        charGenerator.resultBlock = { [weak self] htmlString in
            self?.getSavedChars()
        }
        
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        updateConstraints()
        setUI()
        charGenerator = CharacterHTMLBuilder.defaultBuilder()
    }
    

    func setUI() {
        let collviewHeight = 275 * widthRatio
        var fr = carouselView.frame
        fr.size.height = collviewHeight
        carouselView.frame = fr
        carouselView.type = .linear
        
    }
    
    func updateConstraints() {
        if let horizontalConstraints = horizontalConstraints {
            for constraint in horizontalConstraints {
                let v1 = constraint.constant
                let v2 = v1 * widthRatio
                constraint.constant = v2
            }
        }
    }

}


//MARK:- IBActions
extension SavedCharListVC {
    @IBAction func createNewChar_btnClicked(_ sender: UIButton) {
        self.performSegue(withIdentifier: "NewCharVCSegue", sender: nil)
    }

    @IBAction func deleteChar_btnClicked(_ sender: UIButton) {
        let char = savedChars[currentCharIndex]
        self.deleteCharacter(char: char)
    }
    
    @IBAction func editChar_btnClicked(_ sender: UIButton) {
        let char = savedChars[currentCharIndex]
    }

    @IBAction func shareChar_btnClicked(_ sender: UIButton) {
        let char = savedChars[currentCharIndex]
    }

    @IBAction func emojis_btnClicked(_ sender: UIButton) {
    }

}


//MARK:- TableView DataSource and Delegate
extension SavedCharListVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "actionButtonCell")!
            return cell
            
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "createCharBtnCell")!
            return cell
        } else {//personalizedAdsCell
            let cell = tableView.dequeueReusableCell(withIdentifier: "personalizedAdsCell")!
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0{
            return 80
        } else if indexPath.row == 1 {
            return 150
        } else {
            return 300
        }
    }
}

//MARK:- iCarousel DataSource and Delegate
extension SavedCharListVC : iCarouselDelegate, iCarouselDataSource {
    func numberOfItems(in carousel: iCarousel) -> Int {
        return savedChars.count
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        var itemView: CarouselItemView
        if let iView = view as? CarouselItemView {
            itemView = iView
        } else {
            itemView = CarouselItemView.loadView()
            itemView.frame = CGRect(x: 0, y: 0, width: 180 * widthRatio, height: 275*widthRatio)
        }
        
        let char = savedChars[index]
        if let html = char.charHtml {
            itemView.htmlString = html
        } else {
            charGenerator.buildCharHTMLWith(choices: char.choices, block: { html in
                itemView.htmlString = html
            })
        }

        return itemView
    }
    
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        return value //
    }
    
    func carousel(_ carousel: iCarousel, didSelectItemAt index: Int) {
        currentCharIndex = index
    }
}

//MARK:- API Calls
extension SavedCharListVC {
    func deleteCharacter(char: Character) {
        APICall.shared.deleteCharacter_APICall(createdDate: char.createdDate) { (response, success) in
            if success {
               if let index =  self.savedChars.index(where: { (ch) -> Bool in
                    return char.createdDate == ch.createdDate
               }) {
                self.savedChars.remove(at: index)
                DispatchQueue.main.async {
                    self.carouselView.reloadData()
                }
            }
        }
    }
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
                        character.createdDate = json["date_created"] as! String
                        character.name = json["saved_name"] as! String
                        return character
                    })
                    
                    DispatchQueue.main.async {
                        self.carouselView.reloadData()
                    }
                }
                
            } else {
                
            }
        }
    }
    

}

