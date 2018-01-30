//
//  Constant.swift
//  ClairaBellaDemo
//
//  Created by Vikash Kumar on 05/09/17.
//  Copyright © 2017 Vikash Kumar. All rights reserved.
//

import UIKit



let twitterConsumerKey = "DvECLbI40YUIJTVqiQaCzK4Ge" //vikashbiwal twitter acount
let twitterConsumerSecret = "EY2u50jWgNCchzLLG59LRKDZpjjxFrBKhwhbqpBeaWmYzhqFet"











//Extension

extension String {
    func trimmedString()->String {
       return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
}


extension UIView {
    func generateImage()->UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.isOpaque, 2.0)
        if let context = UIGraphicsGetCurrentContext() {
            self.layer.render(in: context)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return image
        }
        return nil
    }

}
