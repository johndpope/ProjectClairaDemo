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
    @IBOutlet var collView: UICollectionView!
    
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
                self?.collView.reloadData()
            }
        }
    }
}

//MARK: CollectionView DataSource and Delegate
extension ViewController : UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return charGenerator.choiceMenus.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        let menu = charGenerator.choiceMenus[indexPath.row]
        cell.imgView.setImage(url: URL(string: menu.icon)!)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 60, height: 60)
    }
}


class CollectionViewCell: UICollectionViewCell {
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var imgView: UIImageView!
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
