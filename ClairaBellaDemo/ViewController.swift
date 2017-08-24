//
//  ViewController.swift
//  ClairaBellaDemo
//
//  Created by Vikash Kumar on 17/08/17.
//  Copyright © 2017 Vikash Kumar. All rights reserved.
//

import UIKit


class ViewController: UIViewController {

    @IBOutlet var webView: UIWebView!
    @IBOutlet var tableView: UITableView!
    
    var charGenerator: CharacterGenerator! {
        didSet {
            setCharGeneratorResultBlock()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        charGenerator = CharacterGenerator()
    }
    
    
    func setCharGeneratorResultBlock() {
        charGenerator.resultBlock = { [weak self] htmlString in
            self?.webView.loadHTMLString(htmlString, baseURL: nil)
        }
        
        charGenerator.interfaceMenuResultBlock = {[weak self] menus in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    //MARK: TableViewDelegate and DataSource
    

}

extension ViewController : UITableViewDelegate, UITableViewDataSource {
    
    var sectionCount: Int {
        var count = 1
        
        if let selectedMenu = charGenerator.choiceMenus.filter({$0.selected}).first {
            count += selectedMenu.choice.options.isEmpty ? 0 : 1
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? 100 : 60
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionCount
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell") as! MenuTableViewCell
            cell.menus = charGenerator.choiceMenus
            cell.viewcontroller = self
            return cell

        } else {//optionsCell
            let cell = tableView.dequeueReusableCell(withIdentifier: "optionsCell") as! OptionsTableViewCell
            cell.options = charGenerator.choiceMenus.filter({$0.selected}).first?.choice.options ?? []
            
            return cell
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
        
    }

}


class CollectionViewCell: UICollectionViewCell {
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var imgView: UIImageView!
}



class MenuTableViewCell: UITableViewCell,  UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    @IBOutlet var collView: UICollectionView!
    @IBOutlet var lblTitle: UILabel!
   weak var viewcontroller: ViewController?
    
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
        viewcontroller?.tableView.reloadData()
    }

}

class OptionsTableViewCell: UITableViewCell,  UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    @IBOutlet var collView: UICollectionView!
    var options = [ChoiceOption]()
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return options.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        let option = options[indexPath.row]
        //cell.imgView.setImage(url: URL(string: menu.icon)!)
        cell.lblTitle.text = option.name
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 50, height: 50)
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
