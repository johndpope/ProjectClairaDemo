//
//  ViewController.swift
//  ClairaBellaDemo
//
//  Created by Vikash Kumar on 17/08/17.
//  Copyright © 2017 Vikash Kumar. All rights reserved.
//-

import UIKit


class CharacterBuilderVC: ParentVC {
    
    @IBOutlet var webView: UIWebView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var btnSave: UIButton!
    @IBOutlet var indicator: IndicatorView!

    var completionBlock: (Bool)-> Void = {_ in}
    
    var interfaceMenus = [ChoiceMenu]()
    
    // save character before edit start. Used for restore character's original state while user cancel editing.
    //This variable is only used during character editing.
    var copyedCharacter: Character!

    var selectedMenu: ChoiceMenu? = nil {
        willSet {
            //unselect previous selected menu
            selectedMenu?.selected = false
        }
        
        didSet{
            selectedMenu?.selected = true
            colorChoice = nil
            if let ch = selectedMenu!.choices.filter({$0.type == .circle}).first {
               colorChoice = ch
            } else {
                if let ch = selectedMenu!.choices.filter({$0.type == .square}).first {
                    if !ch.options.first!.choices.isEmpty {
                        colorChoice = ch.options.first!.choices.first
                    }
                }
            }
        }
    }
    
    //colorChoice used to showing color option at colorGlint view.
    var colorChoice: CharacterChoice?
    
    var selectedHairColorOption: ChoiceOption!
    
    var charGenerator: CharacterHTMLBuilder! {
        didSet {
            setCharGeneratorResultBlock()
        }
    }
    
    var isCharacterEditMode = false
    var character: Character!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.scrollView.setZoomScale(1.05, animated: false)
        btnSave.isHidden = true
        
        charGenerator = CharacterHTMLBuilder.shared
        
        if !isCharacterEditMode {
            character = Character()
            character.choices = charGenerator.defaultChoices
            charGenerator.upateCharacter(choices: character.choices)
        } else {
            copyedCharacter = character.copy() as! Character
        }
        
        self.loadInterfaceMenus()
        
        if let charHtml = character?.charHtml {
            webView.loadHTMLString(charHtml, baseURL: nil)
            btnSave.isHidden = false
        }
    }
    
    
    func setCharGeneratorResultBlock() {
        charGenerator.resultBlock = { [weak self] htmlString in
            
            self?.character.charHtml = htmlString
            DispatchQueue.main.async {
                self?.webView.loadHTMLString(htmlString, baseURL: nil)
            }
        }
        
    }
    
    func reloadInterfaceMenus() {
        tableView.reloadData()
    }
    
    func loadInterfaceMenus() {
        indicator.startAnimating()
        CharBuilderAPI.shared.getInterface_json { menus in
            self.interfaceMenus = menus
            self.selectedMenu = menus.first
            
            let body = menus.filter({$0.title == "Body"}).first!
            body.choices[1].choiceId = "skin_tone" //api have skin_colour instead of skin_tone thats why need this line.
            
            let hair = menus.filter({$0.title == "Hair"}).first!
            let hairOption = hair.choices[1].options.first
            hairOption?.selected = true
            self.selectedHairColorOption = hairOption
            
            DispatchQueue.main.async {
                self.indicator.stopAnimating()
                self.tableView.reloadData()
                self.btnSave.isHidden = false
            }
        }

    }
}

//MARK:- IBActions
extension CharacterBuilderVC {
    @IBAction func btnCancel_clicked(_ sender: UIButton) {
        
        
        let otherAlert = UIAlertController(title: "Exit Character Builder", message: "Exit & discard unsaved changes? ", preferredStyle: UIAlertControllerStyle.alert)
        
        
        let callFunction = UIAlertAction(title: "YES", style: .default, handler: {alert in
            if self.isCharacterEditMode {
                self.character = self.copyedCharacter
            }
            _ = self.navigationController?.dismiss(animated: true, completion: nil)
        } )
        
        let dismiss = UIAlertAction(title: "NO", style: .cancel, handler: nil)
        
        // relate actions to controllers
        otherAlert.addAction(callFunction)
        otherAlert.addAction(dismiss)
        
        present(otherAlert, animated: true, completion: nil)
    }
    
    
    @IBAction func saveCharacter_btnClicked(_ sender: UIButton) {
        guard let _ = character.charHtml else {
            return
        }
        if let  savCharVC = self.storyboard?.instantiateViewController(withIdentifier: "SaveCharacterVC") as? SaveCharacterVC {
            if isCharacterEditMode {
                savCharVC.character = self.character
                
            } else {
                savCharVC.character  = character
                
            }
            savCharVC.isCharacterEditMode = self.isCharacterEditMode
            self.navigationController?.pushViewController(savCharVC, animated: true)
        }
    }

}

//MARK:- TableViewDelegate and DataSource
extension CharacterBuilderVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 70
        } else {
            let choice = indexPath.row == 0 ? selectedMenu!.choices.first! : colorChoice!

            var height: CGFloat
            
            if let _ = colorChoice {
                height = (tableView.frame.height - 70) - 50
                return choice.type == .square ?   height : 50
            } else {
                height = (tableView.frame.height - 70)
                return choice.type == .square ?   height : 50
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1 + (((selectedMenu?.choices.count ?? 0) > 0) ? 1 : 0)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return 1 + (colorChoice == nil ? 0 : 1)
        }

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell") as! MenuTableViewCell
            cell.menus = interfaceMenus
            cell.viewcontroller = self
            return cell
            
        } else {//optionsCell
            let choice = indexPath.row == 0 ? selectedMenu!.choices.first! : colorChoice!
            let cellIdentifier = choice.type == .square ? "squareOptionsCell" : "circleOptionsCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! OptionsTableViewCell
            cell.viewcontroller = self
            cell.choice = choice//optionsList[indexPath.section-1]
            return cell
        }
    }
    
    func setSelected(choice: CharacterChoice) {
        guard let selectedOption = choice.options.filter({$0.selected}).first else {return}
        character!.choices[choice.choiceId] = selectedOption.name
        
        charGenerator.upateCharacter(choices: character!.choices)

        if !selectedOption.choices.isEmpty {
            setSelected(choice: selectedOption.choices.first!)
        }
    }
    
    func changeUserSelection() {
        for choice in selectedMenu!.choices {
            setSelected(choice: choice)
        }
    }
    
    
}


class CollectionViewCell: UICollectionViewCell {
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var imgView: UIImageView!
}



class MenuTableViewCell: UITableViewCell,  UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    @IBOutlet var collView: UICollectionView!
    @IBOutlet var lblTitle: UILabel!
    weak var viewcontroller: CharacterBuilderVC?
    
    var menus = [ChoiceMenu]() {
        didSet {
            lblTitle.text = ""
            if let selectedMenu = menus.filter({$0.selected}).first {
                lblTitle.text = selectedMenu.heading
            }
            collView.reloadData()
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menus.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        let menu = menus[indexPath.row]
        
        cell.imgView.setImage(url: URL(string: menu.icon)!)
        cell.lblTitle.text = menu.title
        if menu.selected {
            cell.backgroundColor = UIColor(colorLiteralRed: 229.0/255.0, green: 17.0/255.0, blue: 152.0/255.0, alpha: 1)
            //cell.layer.borderWidth = 2
        } else  {
            cell.backgroundColor = UIColor(colorLiteralRed: 239.0/255.0, green: 153.0/255.0, blue: 220.0/255.0, alpha: 1)
            //cell.layer.borderWidth = 0
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 70, height: 70)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //menus.forEach({$0.selected = false})
        let menu = menus[indexPath.row]
        lblTitle.text = menu.heading
        viewcontroller?.selectedMenu = menu
        viewcontroller?.reloadInterfaceMenus()
        //viewcontroller?.changeUserSelection()
    }
    
    
}

class OptionsTableViewCell: UITableViewCell,  UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    @IBOutlet var collView: UICollectionView!
    var choice: CharacterChoice! {
        didSet {
            if choice.type == .square {
                collView.contentInset = UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 0)
            }
            collView.reloadData()
        }
    }
    
    weak var viewcontroller: CharacterBuilderVC?
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return choice?.options.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        let option = choice.options[indexPath.row]
        
        var iconName = option.iconName
        if choice.choiceId == "hair_style" {
             iconName = option.iconName + viewcontroller!.selectedHairColorOption.iconName
        }
        cell.imgView.image = UIImage(named: iconName)
        cell.lblTitle.text = ""//option.name
        
        cell.imgView.layer.cornerRadius = choice.type == .circle ? cell.imgView.frame.width/2 : 0
        cell.imgView.clipsToBounds = true
        
        if option.selected {
            cell.imgView.layer.borderColor = UIColor.red.cgColor
            cell.imgView.layer.borderWidth = 2
        } else  {
            cell.imgView.layer.borderColor = UIColor.clear.cgColor
            cell.imgView.layer.borderWidth = 0
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if choice.type == .square {
            let height = (collView.frame.height - 4 - 8)/2

            //let width = (collView.frame.width - 12)/4
            return CGSize(width: height, height: height)
        } else {
            return CGSize(width: 50, height: 50)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let option = choice.options[indexPath.row]
        choice.options.forEach({$0.selected = false})
        option.selected = true
        if choice.type == .square && !option.choices.isEmpty {
            viewcontroller?.colorChoice  = option.choices.first
        }
        
        if choice.type == .circle && choice.choiceId == "hair_colour" {
            viewcontroller?.selectedHairColorOption = option
        }
        
        viewcontroller?.reloadInterfaceMenus()
        viewcontroller?.changeUserSelection()
    }
    
}







extension UIImageView {
    
    func setImage(url: URL, placeholder: UIImage? = nil, completion:((UIImage?)->Void)? = nil)  {
        self.image = placeholder
        ImageCache.downloadImage(from: url) {image in
            DispatchQueue.main.async {
                if let img = image {
                    self.image = img
                }
                completion?(image)
            }
        }
    }
}


//ImageCache
class ImageCache {
    static let sharedCache: NSCache<AnyObject, AnyObject> = {
        let cache = NSCache<AnyObject, AnyObject>()
        cache.name = "ImageStorageCache"
        cache.countLimit = 1000
        cache.totalCostLimit = 100*1024*1024
        return cache
    }()
    
    
    class func downloadImage(from url: URL, completion:@escaping ((UIImage?)->Void)) {
        if let image = ImageCache.sharedCache.object(forKey: url.absoluteString as AnyObject) as? UIImage {
            completion(image)
        } else {
            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                if let _ = error {
                    //print(err.localizedDescription)
                    completion(nil)
                } else {
                    if let data = data {
                        if let image = UIImage(data: data) {
                            ImageCache.sharedCache.setObject(image, forKey: url.absoluteString as AnyObject, cost: data.count)
                            completion(image)
                        } else {
                            completion(nil)
                        }
                    } else {
                        completion(nil)
                    }
                }
            }).resume()
        }
    }
    
}
