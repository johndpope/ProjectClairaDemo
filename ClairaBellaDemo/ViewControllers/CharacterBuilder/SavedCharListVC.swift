//
//  SavedCharListVC.swift
//  ClairaBellaDemo
//
//  Created by Vikash Kumar on 29/08/17.
//  Copyright © 2017 Vikash Kumar. All rights reserved.
//

import UIKit
import iCarousel

var userSelectedCharForEmoji: Character?

class SavedCharListVC: ParentVC {
    @IBOutlet var tableView: UITableView!
    @IBOutlet var tblHeaderView: UIView!
    @IBOutlet var carouselView: iCarousel!
    @IBOutlet var emptyCharactersView: UIView!
    @IBOutlet var indicatorView: IndicatorView!
    @IBOutlet var lblCharName: UILabel!
    @IBOutlet var lblCreatedDate: UILabel!
    @IBOutlet var checkBox: UIButton!
    @IBOutlet var btnNewChar: UIButton!
    @IBOutlet var btnShare: UIButton!
    @IBOutlet var btnCreateEmojis: UIButton!
    @IBOutlet var btnsStackView: UIStackView!
    @IBOutlet var lblMainChar: UILabel!
    @IBOutlet var btnEdit: UIButton!
    @IBOutlet var seeMoreImgView: UIImageView!
    
    lazy var dateFormatter : DateFormatter =  {
        let df = DateFormatter()
        df.dateFormat = "yyyy, mmm dd"
        return df
    }()
    
    var savedChars = [Character]()
    
    var charGenerator: CharacterHTMLBuilder! {
        didSet {
        }
    }
    
    var currentCharIndex : Int {
        return carouselView.currentItemIndex
    }
    


    override func viewDidLoad() {
        super.viewDidLoad()
        seeMoreImgView.isHidden = !(Character.myCharacters.count > 1)
        self.savedChars = Character.myCharacters


        self.setUI()
        self.setNotificaitonObserver()
        self.showHideEmptyItemsView()
        
        charGenerator = CharacterHTMLBuilder.shared
        carouselView.bounces = false
        carouselView.reloadData()
        setCurrentChartInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    //This func should call from first controller of tabbar.
    
    
    func setUI() {
        let carouselViewHeight = 275 * widthRatio
        var fr = carouselView.frame
        fr.size.height = carouselViewHeight
        carouselView.frame = fr
        carouselView.type = .linear
        
        var headerviewFrame = tblHeaderView.frame
        headerviewFrame.size.height *= widthRatio
        tblHeaderView.frame = headerviewFrame
        
//        btnNewChar.layer.cornerRadius = 5
//        btnNewChar.layer.borderColor = UIColor.white.cgColor
//        btnNewChar.layer.borderWidth = 1
//        btnNewChar.clipsToBounds = true
//        
//        btnShare.layer.cornerRadius = 5
//        btnShare.layer.borderColor = UIColor.white.cgColor
//        btnShare.layer.borderWidth = 1
//        btnShare.clipsToBounds = true

    }
    
    
    //set selected char's info
    func setCurrentChartInfo() {
        let itemIndex = carouselView.currentItemIndex
        if itemIndex >= 0 && itemIndex < savedChars.count {
            let char = savedChars[carouselView.currentItemIndex]
            lblCharName.text = char.name
            checkBox.isSelected = char.isMainChar
            lblCreatedDate.text = ""
            
//            btnCreateEmojis.setTitle("View \(char.name) Emoji's", for: .normal)
            
            if let date = dateFormatter.date(from: char.createdDate, format: "yyyy-MM-dd'T'HH:mm:ss.SSSZ") {
                print(date)
                let dateString = dateFormatter.dateString(from: date, to: "MMM d, yyyy h:mm a")
                lblCreatedDate.text = dateString
            }
        }
    }

    //MARK:- Navigations
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
        } else if segue.identifier == "ToShareVCSegue" {
            let shareVC = segue.destination as! ShareCharacterVC
            shareVC.comeFromHomeScreen = true
            shareVC.character = savedChars[carouselView.currentItemIndex]
        }
    }
    
    //MARK:- Notificaitons
    
    func setNotificaitonObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.newCharacterAdded(_:)), name: NSNotification.Name(rawValue: "NewCharacterAddedNotification"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.characterUpdateNotification(_:)), name: NSNotification.Name(rawValue: "CharacterUpdateNotification"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.characterLoadingFinish(_:)), name: NSNotification.Name(rawValue: "CharactersLoadingFinish"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.characterLoadingFinish(_:)), name: NSNotification.Name(rawValue: "CharacterBuilderJsonLoadingFinish"), object: nil)

        
    }

    func newCharacterAdded(_ nf: Notification) {
        if let newChar = nf.userInfo?["NewChar"] as? Character {
            savedChars.append(newChar)
            showHideEmptyItemsView()
            carouselView.insertItem(at: savedChars.count-1, animated: true)
            setCurrentChartInfo()

            //Navigate to emoji screen for genereate emoji for newly created character.
            if let _ = userSelectedCharForEmoji {
                if let index = self.emojisTabIndex {
                    self.tabBarController?.selectedIndex = index
                }
            } else if let _ = selectedCharForPostcard {
                if let index = self.postcardsTabIndex {
                    self.tabBarController?.selectedIndex = index
                }
            }

        }
    }
    
    func characterUpdateNotification(_ nf: Notification) {
        carouselView.reloadItem(at: carouselView.currentItemIndex, animated: true)
        tableView.reloadData()
        setCurrentChartInfo()
        
        //Navigate to emoji screen for genereate emoji for updated character.
        if let char = nf.userInfo?["updatedChar"] as? Character {
            
            if let _ = userSelectedCharForEmoji {
                if let index = self.emojisTabIndex {
                    self.tabBarController?.selectedIndex = index
                }
            } else if let _ = selectedCharForPostcard {
                if let index = self.postcardsTabIndex {
                    self.tabBarController?.selectedIndex = index
                }
            }
        }

    }
    
    func characterLoadingFinish(_ nf: Notification) {
       savedChars = Character.myCharacters
        carouselView.reloadData()
        showHideEmptyItemsView()
    }
    
    //hide all buttons and lables of characters 
    func hideCharacterInfoViews(_ shouldShow: Bool) {
        lblCharName.isHidden = shouldShow
        lblCreatedDate.isHidden = shouldShow
        btnsStackView.isHidden = shouldShow
        checkBox.isHidden = shouldShow
        lblMainChar.isHidden = shouldShow
        btnEdit.isHidden = shouldShow
        seeMoreImgView.isHidden = shouldShow
    }
    
    func showEmojiFor(charIndex: Int) {
        let char = savedChars[charIndex]
        userSelectedCharForEmoji = char
        if let index = self.emojisTabIndex {
            self.tabBarController?.selectedIndex = index
        }

    }
}


//MARK:- IBActions
extension SavedCharListVC {
    @IBAction func createNewChar_btnClicked(_ sender: UIButton?) {
        self.performSegue(withIdentifier: "NewCharVCSegue", sender: nil)
    }

    @IBAction func deleteChar_btnClicked(_ sender: UIButton) {
        
        
        let char = savedChars[currentCharIndex]
        let alert = CharacterAlertView.show(in: self.view, for: char)
        alert.title = "Are you sure you want to delete this character?"
        alert.message = ""
        alert.actionBlock = {btnIndex in
            if btnIndex == 1 {
                self.deleteCharacter(char: char)
            } else {
                
            }
        }

    }
    
    @IBAction func editChar_btnClicked(_ sender: UIButton?) {
        let char = savedChars[currentCharIndex]
        self.performSegue(withIdentifier: "NewCharVCSegue", sender: char)
    }
    
    @IBAction func cellEditChar_btnClicked(_ sender: UIButton) {
        let char = savedChars[sender.tag]
        self.performSegue(withIdentifier: "NewCharVCSegue", sender: char)
    }


    @IBAction func shareChar_btnClicked(_ sender: UIButton) {
        let char = savedChars[currentCharIndex]
        //let shareVC = self.storyboard?.instantiateViewController(withIdentifier: "ShareCharacterVC") as! ShareCharacterVC
        //shareVC.comeFromHomeScreen = true
        //shareVC.character = char
        
        selectedCharForPostcard = char
        if let index = self.postcardsTabIndex {
            self.tabBarController?.selectedIndex = index
        }
        

        //self.navigationController?.pushViewController(shareVC, animated: true)
    }

    @IBAction func btn_CreateEmojisClicked(_ sender: UIButton?) {
        showEmojiFor(charIndex: carouselView.currentItemIndex)
    }
    
    @IBAction func cellEmojis_btnClicked(_ sender: UIButton) {
        showEmojiFor(charIndex: sender.tag)
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
    
    @IBAction func btnCheckBox_clicked(_ sender: UIButton) {
        checkBox.isSelected = !checkBox.isSelected

        if self.checkBox.isSelected {
            let char = Character.myCharacters[currentCharIndex]
            //let char = Character.myCharacters.remove(at: currentCharIndex)
            UserDefaults.standard.set(char.createdDate, forKey: "MainCharacter")
            
//            Character.myCharacters.insert(char, at: 0)
//            carouselView.reloadData()
        } else {
            UserDefaults.standard.set(nil, forKey: "MainCharacter")
        }
        
        

    }
    

}


//MARK:- TableView DataSource and Delegate
extension SavedCharListVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedChars.isEmpty ? 0 : 2
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "characterListCell") as! CharacterListCell
            cell.myCharsVC = self
            cell.tblView?.reloadData()
            return cell
            
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "createCharBtnCell")!
            return cell
            
        } else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "bagAdsCell")!
            return cell

        } else if indexPath.row == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "productsCell")!
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "personalizedAdsCell")!
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0{
            return CGFloat(savedChars.count * 120) + 40
        } else if indexPath.row == 1 {
            return 300 * widthRatio
        } else if indexPath.row == 2 {
            return 450 * widthRatio
        } else if indexPath.row == 3 {
            return 585 * widthRatio
        } else {
            return 300 * widthRatio
        }
    }
}

//MARK:- iCarousel DataSource and Delegate
extension SavedCharListVC : iCarouselDelegate, iCarouselDataSource {
    func numberOfItems(in carousel: iCarousel) -> Int {
        return savedChars.count + 1
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        var itemView: CarouselItemView
        if index == (carousel.numberOfItems-1){
            itemView = CarouselItemView.loadLastTile()
            itemView.frame = CGRect(x: 0, y: 0, width: 172 * widthRatio, height: 275*widthRatio)
            itemView.tag = 1000
            return itemView
            
        } else {
            
            if let iView = view as? CarouselItemView, iView.tag != 1000{
                itemView = iView
            } else {
                itemView = CarouselItemView.loadView()
                itemView.frame = CGRect(x: 0, y: 0, width: 172 * widthRatio, height: 300*widthRatio)
            }
            
            let char = savedChars[index]
            if  !char.charHtml.isEmpty {
                itemView.htmlString = char.charHtml
            } else {
                charGenerator.buildCharHTMLWith(choices: char.choices, block: { html in
                    itemView.htmlString = html
                    char.charHtml = html
                })
            }
            
            return itemView
        }
    }
    
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        return value //
    }
    
    func carouselCurrentItemIndexDidChange(_ carousel: iCarousel) {
        hideCharacterInfoViews(carousel.currentItemIndex == (carousel.numberOfItems-1))
        seeMoreImgView.isHidden = carousel.currentItemIndex >= (carousel.numberOfItems-2)

        if carousel.currentItemIndex >= 0 {
            setCurrentChartInfo()
        }
    }
    
    func carouselDidEndDecelerating(_ carousel: iCarousel) {
        hideCharacterInfoViews(carousel.currentItemIndex == (carousel.numberOfItems-1))
        seeMoreImgView.isHidden = carousel.currentItemIndex >= (carousel.numberOfItems-2)
        
    }
    
    func carousel(_ carousel: iCarousel, didSelectItemAt index: Int) {
        if index == (carousel.numberOfItems-1) && carousel.currentItemIndex == index {
            createNewChar_btnClicked(nil)
        } else if index == carousel.currentItemIndex {
            editChar_btnClicked(nil)
        }
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
                    Character.myCharacters.remove(at: index)
                    self.carouselView.removeItem(at: self.carouselView.currentItemIndex, animated: true)
                    self.showHideEmptyItemsView()
                    deleteCharacterEmojisFromLocal(char: char)
                }
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

extension DateFormatter {
    func date(from dateString: String, format: String)-> Date? {
        self.dateFormat = format
        return self.date(from: dateString)
    }
    
    func dateString(from date: Date, to format: String)-> String {
        self.dateFormat = format
        return self.string(from: date)
    }
}

//TableCell
class TableCell: UITableViewCell {
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var textField: UITextField!
    
    @IBOutlet var horizontalConstraints: [NSLayoutConstraint]?

    override func awakeFromNib() {
        super.awakeFromNib()
        updateConstraint()
    }
    
    func updateConstraint() {
        if let horizontalConstraints = horizontalConstraints {
            for constraint in horizontalConstraints {
                let v1 = constraint.constant
                let v2 = v1 * widthRatio
                constraint.constant = v2
            }
        }
    }

}



//CharacterList cell for tableview.
//Characters will showing vertically at My characters screen.

class CharacterListCell: TableCell, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet var tblView: UITableView!
    weak var myCharsVC: SavedCharListVC?
    
    override func awakeFromNib() {
        super.awakeFromNib()
            tblView.bounces = false
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Character.myCharacters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "characterCell") as! CharacterCell
        let char = Character.myCharacters[indexPath.row]
        cell.lblCharacterName.text = char.name
        cell.setBtnTag(tag: indexPath.row)
        
        if  !char.charHtml.isEmpty {
            cell.webview.loadHTMLString(char.charHtml, baseURL: nil)
        } else {
            if let charGenerator = myCharsVC?.charGenerator {
                charGenerator.buildCharHTMLWith(choices: char.choices, block: { html in
                    char.charHtml = html
                    cell.webview.loadHTMLString(char.charHtml, baseURL: nil)
                })
            }
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        myCharsVC?.showEmojiFor(charIndex: indexPath.row)
    }
}

class CharacterCell: TableCell {
    @IBOutlet var lblCharacterName: UILabel!
    @IBOutlet var webview: UIWebView!
    @IBOutlet var btnEdit: UIButton!
    @IBOutlet var btnEmojis: UIButton!
    
    func setBtnTag(tag: Int) {
        btnEdit?.tag = tag
        btnEmojis?.tag = tag
    }
    
}



