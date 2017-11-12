//
//  CBTabbarVC.swift
//  ClairaBellaDemo
//
//  Created by Vikash Kumar on 12/11/17.
//  Copyright © 2017 Vikash Kumar. All rights reserved.
//

import UIKit

class CBTabbarVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
      
        self.setTabbarAppearance()
        self.setTabbarItemImages()
    }
    

    func setTabbarAppearance() {
        UITabBar.appearance().tintColor = UIColor(red: 225.0/255.0, green: 57.0/255.0, blue: 169.0/255.0, alpha: 1.0)
        
        UITabBarItem.appearance().badgeColor = UIColor(red: 74.0/255.0, green: 144.0/255.0, blue: 226.0/255.0, alpha: 1.0)
        
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.white], for: .selected)
        
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.lightGray], for: .normal)
    }

    func setTabbarItemImages() {
        for item in self.tabBar.items!{
            item.selectedImage = item.selectedImage?.withRenderingMode(.alwaysOriginal)
            item.image = item.image?.withRenderingMode(.alwaysOriginal)
            
        }
        
        let numberOfItems = CGFloat(self.tabBar.items!.count)
        
        let tabBarItemSize = CGSize(width: tabBar.frame.width / numberOfItems, height: tabBar.frame.height)
        
        let tabBgColor = UIColor(colorLiteralRed: 250.0/255.0, green: 185.0/255.0, blue: 237.0/255.0, alpha: 1)
        tabBar.selectionIndicatorImage = UIImage.imageWithColor(color: tabBgColor, size: tabBarItemSize).resizableImage(withCapInsets: .zero)
        
        tabBar.frame.size.width = self.view.frame.width + 4
        tabBar.frame.origin.x = -2
        
    }

}


extension UIImage {
    class func imageWithColor(color: UIColor, size: CGSize) -> UIImage {
        let rect: CGRect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}
