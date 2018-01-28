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
    @IBOutlet var characterContainterView: UIView!
    @IBOutlet var charImageView: UIImageView!
    
    var completionBlock: (Bool)-> Void = {_ in}
    
    var showColorOption = false
    
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
            setColorChoice()
        }
    }
    
    //colorChoice used to showing color option at colorGlint view.
    var colorChoice: CharacterChoice?
    
    ///This variable is used to generate icon name for hair style with selected color.
    var selectedHairColorOption: ChoiceOption!
    
    var charGenerator: CharacterHTMLBuilder! {
        didSet {
            setCharGeneratorResultBlock()
        }
    }
    
    var isCharacterEditMode = false
    var character: Character!
    
    let emojiCustomizableChoices = ["skin_tone", "hair_colour", "hair_style", "expression", "eye_colour", "eye_wear", "eye_wear_colour" , "head_wear", "head_wear_colour"]
    
    var updatedChoices = Set<String>()
    
    var needsToRegenerateEmojis: Bool {
        for item in updatedChoices {
            if emojiCustomizableChoices.contains(item) {
                return true
            }
        }
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnSave.isHidden = true
        webView.delegate = self
        charGenerator = CharacterHTMLBuilder(builder: CharacterHTMLBuilder.shared)
        
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
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    
    func setColorChoice() {
        
        colorChoice = nil
        guard let selectedMenu = selectedMenu else {
            showColorOption = false
            return
        }

        
        if let ch = selectedMenu.choices.filter({$0.type == .circle}).first {
            colorChoice = ch
        } else {
            if let selectedSquarChoice = selectedMenu.choices.filter({$0.type == .square}).first {
                if !selectedSquarChoice.options.first!.choices.isEmpty {
                    let selectedOptions = selectedSquarChoice.options.filter({$0.selected})
                    
                    colorChoice = selectedOptions.isEmpty ? selectedSquarChoice.options.first!.choices.first : selectedOptions.first?.choices.first
                    
                    //set selected a default color if user haven't selected any color from interface..
                    if let _ = colorChoice?.options.filter({$0.selected}).first {
                    } else {
                        colorChoice?.options.first?.selected = true
                    }
                }
            }
        }
        
        showColorOption = colorChoice == nil ? false : true
        
        //if selected squar menu is none then color option hide.
    
        if let _ = colorChoice, let selectedSquareOption = selectedMenu.choices.filter({$0.type == .square}).first?.options.filter({$0.selected}).first {
            showColorOption = selectedSquareOption.name.lowercased() != "none"
        }
    }
    
    //API Calls
    func loadInterfaceMenus() {
        indicator.startAnimating()
        CharBuilderAPI.shared.getInterface_json { menus in
            if menus.isEmpty {
                DispatchQueue.main.async {self.indicator.stopAnimating()}
                return
            }
            
            self.interfaceMenus = menus
            self.selectedMenu = menus.first
            
            //set default option selected in all Menu and sub Menus.
            for item in menus {
                for choice in item.choices {
                    if let characterChoiceValue = self.character.choices[choice.choiceId] {
                        for option in choice.options {
                            if option.name == characterChoiceValue {
                                option.selected = true
                            }
                        }
                    }
                }
            }
            
            //sepecific condition only for 'Hair' Menu.
            //Because hair style images name is generated by using selected color option. 
            //hair style image name  = OptionIconName + selectedColorName
            
            if let hair = menus.filter({$0.title == "Hair"}).first {
                let hairOption = hair.choices[1].options.filter({$0.selected}).first
                self.selectedHairColorOption = hairOption

            }
            
            DispatchQueue.main.async {
                self.indicator.stopAnimating()
                self.tableView.reloadData()
                self.btnSave.isHidden = false
            }
        }

    }
    
    
    func downloadMenuIcon(for menu: ChoiceMenu, cell: CollectionViewCell) {
        if let image = menu.icon {
            cell.imgView.image = image
        } else {
            DispatchQueue.global(qos: .userInitiated).async {
                let imgUrl = documetDirectoryURL().appendingPathComponent("interface/claireabella/v1.0/\(menu.iconName)")
                print(imgUrl)
                if let data = try? Data(contentsOf: imgUrl), let image = UIImage(data: data) {
                    
                    menu.icon = image
                    
                    DispatchQueue.main.async {
                        cell.imgView.image = image
                    }
                    
                }
            }
        }
    }
    
    
    func downloadOptionIcon(for option: ChoiceOption, iconName: String, cell: CollectionViewCell) {
        if let image = option.icon {
            cell.imgView.image = image
        } else {
            DispatchQueue.global(qos: .userInitiated).async {
                let imgUrl = documetDirectoryURL().appendingPathComponent("interface/claireabella/v1.0/\(iconName).png")
                print(imgUrl)
                if let data = try? Data(contentsOf: imgUrl), let image = UIImage(data: data) {
                    
                    option.icon = image
                    
                    DispatchQueue.main.async {
                        cell.imgView.image = image
                    }
                    
                }
            }
        }
        
    }
    

    func generateEmojiImage()->UIImage? {
        
        UIGraphicsBeginImageContextWithOptions(characterContainterView.bounds.size, characterContainterView.isOpaque, 2.0)
        if let context = UIGraphicsGetCurrentContext() {
            characterContainterView.layer.render(in: context)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return image
        }
        return nil
    }

    
}

extension CharacterBuilderVC : UIWebViewDelegate {
    func webViewDidStartLoad(_ webView: UIWebView) {
        charImageView.isHidden = false
        self.showHud()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        if !webView.isLoading {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3, execute: {
                let image = self.generateEmojiImage()
                self.charImageView.image = image
                self.charImageView.isHidden = true

                self.hideHud()
            })
        }

    }
}

//MARK:- IBActions
extension CharacterBuilderVC {
    @IBAction func btnCancel_clicked(_ sender: UIButton) {
        
        let alert = CharacterAlertView.show(in: self.view, for: character)
        alert.title = "Exit Character Builder"
        alert.message = "Do you want to save your character?"
        
        alert.actionBlock = {btnIndex in
            if btnIndex == 1 {
            } else {
                if self.isCharacterEditMode {
                    self.character.charHtml = self.copyedCharacter.charHtml
                    self.character.choices = self.copyedCharacter.choices
                    self.character = self.copyedCharacter
                }
                _ = self.navigationController?.dismiss(animated: true, completion: nil)

            }
        }

    }
    
    
    @IBAction func saveCharacter_btnClicked(_ sender: UIButton) {
//        guard !character.charHtml.isEmpty else {
//            return
//        }
        if let  savCharVC = self.storyboard?.instantiateViewController(withIdentifier: "SaveCharacterVC") as? SaveCharacterVC {
            if isCharacterEditMode {
                savCharVC.character = self.character
                savCharVC.needsToUpdateEmojis = self.needsToRegenerateEmojis
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

            let height = (tableView.frame.height - 70) - (showColorOption ? 50 : 0)
            return choice.type == .square ?   height : 50
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1 + (((selectedMenu?.choices.count ?? 0) > 0) ? 1 : 0)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return 1 + (showColorOption ? 1 : 0)
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
            cell.choice = choice
            return cell
        }
    }
    
    func setSelected(choice: CharacterChoice) {
        guard let selectedOption = choice.options.filter({$0.selected}).first else {return}
        character!.choices[choice.choiceId] = selectedOption.name
        
        
//        charGenerator.upateCharacter(choices: character!.choices)

        if !selectedOption.choices.isEmpty {
            setSelected(choice: selectedOption.choices.first!)
        }
        
    }
    
    func changeUserSelection() {
        self.setColorChoice()
        
        if let colorChoice = colorChoice {
            let selectedColor = colorChoice.options.filter({$0.selected}).first
            if let color = selectedColor {
                color.selected = true
            } else if let color = colorChoice.options.first {
                color.selected = true
                //character.choices[colorChoice.choiceId] = color.name
            }
        }

        for choice in selectedMenu!.choices {
            setSelected(choice: choice)
            updatedChoices.insert(choice.choiceId)
        }
        
        charGenerator.upateCharacter(choices: character!.choices)

        
//        print(image)
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
        //cell.imgView.image = UIImage(named: menu.iconName)
        
        viewcontroller?.downloadMenuIcon(for: menu, cell: cell)

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
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
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
            option.icon = nil
             iconName = option.iconName + viewcontroller!.selectedHairColorOption.iconName
        }
        
        
        cell.imgView.image = nil
        viewcontroller?.downloadOptionIcon(for: option, iconName: iconName, cell: cell)
        
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
            let height = (collView.frame.width - 4 - 8)/4

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
        
        if choice.type == .circle {
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
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

