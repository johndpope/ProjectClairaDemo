//
//  ViewController.swift
//  ClairaBellaDemo
//
//  Created by Vikash Kumar on 17/08/17.
//  Copyright © 2017 Vikash Kumar. All rights reserved.
//-

import UIKit

let widthRatio = UIScreen.main.bounds.width/375

class CharacterBuilderVC: UIViewController {
    
    @IBOutlet var webView: UIWebView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var horizontalConstraints: [NSLayoutConstraint]?
    @IBOutlet var btnSave: UIButton!
    
    var interfaceMenus = [ChoiceMenu]()
    
    // save character before edit start. Used for restore character's original state while user cancel editing.
    //This variable is only used during character editing.
    var copyedCharacter: Character!

    var optionsList = [CharacterChoice]()
    
    var charGenerator: CharacterHTMLBuilder! {
        didSet {
            setCharGeneratorResultBlock()
        }
    }
    
    var isCharacterEditMode = false
    var character: Character!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateConstraints()
        webView.scrollView.setZoomScale(1.1, animated: false)
        btnSave.isHidden = true
        

        if !isCharacterEditMode {
            character = Character()
            character.choices = charGenerator.defaultChoices
            charGenerator.upateCharacter(choices: character.choices)
        } else {
            copyedCharacter = character.copy() as! Character
        }
        
        CharBuilderAPI.shared.getInterface_json { menus in
            self.interfaceMenus = menus
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.btnSave.isHidden = false
            }
        }

        if let charHtml = character?.charHtml {
            webView.loadHTMLString(charHtml, baseURL: nil)
            btnSave.isHidden = false
        }
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
    
    func setCharGeneratorResultBlock() {
        charGenerator.resultBlock = { [weak self] htmlString in
            
            self?.character.charHtml = htmlString
            DispatchQueue.main.async {
                self?.webView.loadHTMLString(htmlString, baseURL: nil)
            }
        }
        
    }
    
    func reloadInterfaceMenus() {
        optionsList.removeAll()
        tableView.reloadData()
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
            _ = self.navigationController?.popViewController(animated: true)
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
    
    func sectionCount(in choice:CharacterChoice)-> Int {
        var subChoice: CharacterChoice?
        if let selectedOption = choice.options.filter({$0.selected}).first {
            subChoice = selectedOption.choice
        }
        
        if !choice.options.isEmpty{
            optionsList.append(choice)
        }
        return choice.options.isEmpty ? 0 : 1 + (subChoice == nil ? 0 : sectionCount(in: subChoice!))
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? 100 : 60
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        let mainMenuChoice = interfaceMenus.filter({$0.selected}).first?.choice
        return 1 + (mainMenuChoice == nil ? 0 : sectionCount(in: mainMenuChoice!))
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell") as! MenuTableViewCell
            cell.menus = interfaceMenus
            cell.viewcontroller = self
            return cell
            
        } else {//optionsCell
            let cell = tableView.dequeueReusableCell(withIdentifier: "optionsCell") as! OptionsTableViewCell
            cell.viewcontroller = self
            cell.choice = optionsList[indexPath.section-1]
            
            return cell
        }
    }
    
    func setSelected(choice: CharacterChoice) {
        guard let selectedOption = choice.options.filter({$0.selected}).first else {return}
        character!.choices[choice.choiceId] = selectedOption.name
        
        charGenerator.upateCharacter(choices: character!.choices)

        if !selectedOption.choice.options.isEmpty {
            setSelected(choice: selectedOption.choice)
        }
    }
    
    func changeUserSelection() {
        setSelected(choice: interfaceMenus.filter({$0.selected}).first!.choice)
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
        
        if menu.selected {
            cell.imgView.layer.borderColor = UIColor.red.cgColor
            cell.imgView.layer.borderWidth = 2
        } else  {
            cell.imgView.layer.borderColor = UIColor.clear.cgColor
            cell.imgView.layer.borderWidth = 0
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 60, height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        menus.forEach({$0.selected = false})
        let menu = menus[indexPath.row]
        menu.selected = true
        lblTitle.text = menu.heading
        viewcontroller?.reloadInterfaceMenus()
        viewcontroller?.changeUserSelection()
    }
    
    
}

class OptionsTableViewCell: UITableViewCell,  UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    @IBOutlet var collView: UICollectionView!
    var choice: CharacterChoice! {
        didSet {
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
        //cell.imgView.setImage(url: URL(string: menu.icon)!)
        cell.lblTitle.text = option.name
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
        return CGSize(width: 50, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let option = choice.options[indexPath.row]
        choice.options.forEach({$0.selected = false})
        option.selected = true
        
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
