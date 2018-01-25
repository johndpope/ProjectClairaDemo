//
//  ShopViewController.swift
//  ClairaBellaDemo
//
//  Created by Vikash Kumar on 07/12/17.
//  Copyright © 2017 Vikash Kumar. All rights reserved.
//

import UIKit

class ShopViewController: ParentVC {
    
    @IBOutlet var collView: UICollectionView!
    
    struct ShopBanner {
        var imgName: String
        var link: String
        var type: BannerType
        enum BannerType {case small, big}
        
        init(imgName: String, link: String, type: BannerType = BannerType.small) {
            self.imgName = imgName
            self.link = link
            self.type = type
        }
    }
    
    enum BannerLinks {
        static let ClaireaBella_TopBanner  = "http://www.toxicfox.co.uk/claireabella?utm_source=CBAPP&utm_medium=CBAPP&utm_campaign=CBAPP"
        
        static let ClaireaBella_Bags = "http://www.toxicfox.co.uk/claireabella/claireabella-fashion-bags-simple?utm_source=CBAPP&utm_medium=CBAPP&utm_campaign=CBAPP"
        
        static let ClaireaBella_Canvas_Bags = "http://www.toxicfox.co.uk/claireabella/claireabella-fashion-bags-simple/claireabella-canvas-bag?utm_source=CBAPP&utm_medium=CBAPP&utm_campaign=CBAPP"
        
        static let ClaireaBella_Christmas = "http://www.toxicfox.co.uk/christmas-gifts/stocking-fillers/claireabella-stocking-fillers?utm_source=CBAPP&utm_medium=CBAPP&utm_campaign=CBAPP"
        
        static let ClaireaBella_Fashion = "http://www.toxicfox.co.uk/claireabella/claireabella-fashion?utm_source=CBAPP&utm_medium=CBAPP&utm_campaign=CBAPP"
        
        static let ClaireaBella_Girls_TopBanner = "http://www.toxicfox.co.uk/claireabella/claireabella-kids?utm_source=CBAPP&utm_medium=CBAPP&utm_campaign=CBAPP"
        
        static let ClaireaBella_Makeup_Bags = "http://www.toxicfox.co.uk/claireabella/claireabella-fashion-bags-simple/claireabella-makeup-bags?utm_source=CBAPP&utm_medium=CBAPP&utm_campaign=CBAPP"
        
        static let ClaireaBella_Mugs = "http://www.toxicfox.co.uk/claireabella/claireabella-home/claireabella-mugs?utm_source=CBAPP&utm_medium=CBAPP&utm_campaign=CBAPP"
        
        static let ClaireaBella_Protective_Cases = "http://www.toxicfox.co.uk/claireabella/claireabella-protective-cases?utm_source=CBAPP&utm_medium=CBAPP&utm_campaign=CBAPP"
        
        static let ClaireaBella_Travel = "http://www.toxicfox.co.uk/claireabella/claireabella-travel?utm_source=CBAPP&utm_medium=CBAPP&utm_campaign=CBAPP"
        
        static let MrCB = "http://www.toxicfox.co.uk/claireabella/mrclaireabella?utm_source=CBAPP&utm_medium=CBAPP&utm_campaign=CBAPP"
        
        static let PetaBella = "http://www.toxicfox.co.uk/petabella?utm_source=CBAPP&utm_medium=CBAPP&utm_campaign=CBAPP"
        
        static let Stationery = "http://www.toxicfox.co.uk/claireabella/claireabella-stationery?utm_source=CBAPP&utm_medium=CBAPP&utm_campaign=CBAPP"

    }
    
    
    var items = [
        ShopBanner(imgName: "ClaireaBella_TopBanner", link: BannerLinks.ClaireaBella_TopBanner, type: .big),
        ShopBanner(imgName: "ClaireaBella_Bags", link: BannerLinks.ClaireaBella_Bags),
        ShopBanner(imgName: "ClaireaBella_Protective_Cases", link: BannerLinks.ClaireaBella_Protective_Cases),
        ShopBanner(imgName: "stationery", link: BannerLinks.Stationery),
        ShopBanner(imgName: "ClaireaBella_Travel", link: BannerLinks.ClaireaBella_Travel),
        ShopBanner(imgName: "ClaireaBella_Makeup_Bags", link: BannerLinks.ClaireaBella_Makeup_Bags),
        ShopBanner(imgName: "ClaireaBella_Canvas_Bags", link: BannerLinks.ClaireaBella_Canvas_Bags),
        ShopBanner(imgName: "ClaireaBella_Fashion", link: BannerLinks.ClaireaBella_Fashion),
        ShopBanner(imgName: "ClaireaBella_Mugs", link: BannerLinks.ClaireaBella_Mugs),
        ShopBanner(imgName: "ClaireaBella_Girls_TopBanner", link: BannerLinks.ClaireaBella_Girls_TopBanner, type: .big),
        ShopBanner(imgName: "MrCB", link: BannerLinks.MrCB, type: .big),
        ShopBanner(imgName: "PetaBella", link: BannerLinks.PetaBella, type: .big)
    ]
    
    
}

extension ShopViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        let item = items[indexPath.item]
        
        cell.imgView.image = UIImage(named: item.imgName)
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let url = URL(string: items[indexPath.item].link) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let item = items[indexPath.item]
        
        if item.type == .big {
            let width = collectionView.frame.width-20
            return CGSize(width: width, height: width * 1.10)
        } else {
            let width = (collectionView.frame.width - 30) / 2
            return CGSize(width: width, height: width * 1.13)
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(10, 10, 10, 10)
    }
}





