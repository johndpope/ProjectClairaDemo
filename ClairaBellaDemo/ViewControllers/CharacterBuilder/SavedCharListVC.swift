//
//  SavedCharListVC.swift
//  ClairaBellaDemo
//
//  Created by Vikash Kumar on 29/08/17.
//  Copyright © 2017 Vikash Kumar. All rights reserved.
//

import UIKit
import iCarousel

class SavedCharListVC: ParentVC {
    @IBOutlet var tableView: UITableView!
    @IBOutlet var carouselView: iCarousel!
    @IBOutlet var emptyCharactersView: UIView!
    @IBOutlet var indicatorView: IndicatorView!
    
    var savedChars = [Character]()
    var charGenerator: CharacterHTMLBuilder! {
        didSet {
            setCharGeneratorResultBlock()
        }
    }
    
    var currentCharIndex : Int {
        return carouselView.currentItemIndex
    }
    
    func setCharGeneratorResultBlock() {
        charGenerator.resultBlock = { [weak self] htmlString in
            self?.getSavedChars()
        }
        
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        charGenerator = CharacterHTMLBuilder.shared
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.newCharacterAdded(_:)), name: NSNotification.Name(rawValue: "NewCharacterAddedNotification"), object: nil)
    }
    
    func newCharacterAdded(_ nf: Notification) {
        if let newChar = nf.userInfo?["NewChar"] as? Character {
            savedChars.append(newChar)
            showHideEmptyItemsView()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setCharGeneratorResultBlock()
        carouselView.reloadData()
    }

    func setUI() {
        let carouselViewHeight = 275 * widthRatio
        var fr = carouselView.frame
        fr.size.height = carouselViewHeight
        carouselView.frame = fr
        carouselView.type = .linear
        
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "NewCharVCSegue" {
            let dest = segue.destination as! UINavigationController
            if let buildVC = dest.viewControllers.first as? CharacterBuilderVC {
                if let char = sender as? Character {
                    buildVC.character = char
                    buildVC.isCharacterEditMode = true
                }
            }

        } else if segue.identifier == "updateCharSegue" {
            let dest = segue.destination as! SaveCharacterVC
            if let char = sender as? Character {
                dest.character = char
                dest.isCharacterEditMode = true
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
        
        func showAlert() {
            let alert = UIAlertController(title: "", message: "Are you sure you want to delete this character ?", preferredStyle: .alert)
            let yesAction = UIAlertAction(title: "Yes", style: .default) { (action) in
                self.deleteCharacter(char: char)
            }
            let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
            alert.addAction(noAction)
            alert.addAction(yesAction)
            self.present(alert, animated: true, completion: nil)
        }
        
        showAlert()
    }
    
    @IBAction func editChar_btnClicked(_ sender: UIButton) {
        let char = savedChars[currentCharIndex]
        self.performSegue(withIdentifier: "NewCharVCSegue", sender: char)
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
        return savedChars.isEmpty ? 0 : 3
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
            return 300 * widthRatio
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
            itemView.frame = CGRect(x: 0, y: 0, width: 172 * widthRatio, height: 275*widthRatio)
        }
        
        let char = savedChars[index]
        if let html = char.charHtml {
            itemView.htmlString = html
        } else {
            charGenerator.buildCharHTMLWith(choices: char.choices, block: { html in
                itemView.htmlString = html
                char.charHtml = html
            })
        }

        return itemView
    }
    
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        return value //
    }
    
}

//MARK:- API Calls
extension SavedCharListVC {
    func deleteCharacter(char: Character) {
        indicatorView.startAnimating()
        APICall.shared.deleteCharacter_APICall(createdDate: char.createdDate) { (response, success) in
            self.indicatorView.stopAnimating()
            if success {
                if let index =  self.savedChars.index(where: { (ch) -> Bool in
                    return char.createdDate == ch.createdDate
                }) {
                    self.savedChars.remove(at: index)
                    self.carouselView.reloadData()
                    self.showHideEmptyItemsView()
                }
            }
        }
    }
    
    func getSavedChars() {
        self.indicatorView.startAnimating()
        APICall.shared.getSavedCharaters_APICall(username: "test@test.com") { (response, success) in
            if success {
                print(response!)
                if let jsonArr = response as? [[String : Any]] {
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
                    
                    self.savedChars = charters.filter({$0.alive})
                    DispatchQueue.main.async {
                        self.carouselView.reloadData()
                        self.showHideEmptyItemsView()
                    }
                }
                
            } else {
                
            }
            DispatchQueue.main.async {
                self.indicatorView.stopAnimating()
            }
        }
    }
    
    func showHideEmptyItemsView() {
        let noSavedItems = self.savedChars.isEmpty
        self.tableView.isHidden = noSavedItems
        self.emptyCharactersView.isHidden = !noSavedItems
        self.tableView.reloadData()
    }
}


//MARK:- IndicatorView
class IndicatorView: UIView {
    @IBOutlet var indicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 5
        self.clipsToBounds = true
        self.isHidden = true
    }
    func startAnimating() {
        self.isHidden = false
        indicator.startAnimating()
    }
    
    func stopAnimating() {
        self.isHidden = true
        indicator.stopAnimating()
    }
}
