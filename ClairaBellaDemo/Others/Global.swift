//
//  Global.swift
//  MrRajo
//
//  Created by Jay Patel on 5/29/17.
//  Copyright © 2017 Jay Patel. All rights reserved.
//

import Foundation
import UIKit

enum UIUserInterfaceIdiom : Int
{
    case unspecified
    case phone
    case pad
}

let app_delegate = UIApplication.shared.delegate as! AppDelegate

let SCREEN_WIDTH         = UIScreen.main.bounds.size.width
let SCREEN_HEIGHT        = UIScreen.main.bounds.size.height
let SCREEN_MAX_LENGTH    = max(SCREEN_WIDTH, SCREEN_HEIGHT)
let SCREEN_MIN_LENGTH    = min(SCREEN_WIDTH, SCREEN_HEIGHT)

let IS_IPHONE_4_OR_LESS  = UIDevice.current.userInterfaceIdiom == .phone && SCREEN_MAX_LENGTH < 568.0
let IS_IPHONE_5          = UIDevice.current.userInterfaceIdiom == .phone && SCREEN_MAX_LENGTH == 568.0
let IS_IPHONE_6          = UIDevice.current.userInterfaceIdiom == .phone && SCREEN_MAX_LENGTH == 667.0
let IS_IPHONE_6_G        = UIDevice.current.userInterfaceIdiom == .phone && SCREEN_MAX_LENGTH >= 667.0
let IS_IPHONE_6_PLUS     = UIDevice.current.userInterfaceIdiom == .phone && SCREEN_MAX_LENGTH == 736.0
let IS_IPAD              = UIDevice.current.userInterfaceIdiom == .pad && SCREEN_MAX_LENGTH >= 1024.0
let IS_IPAD_PRO          = UIDevice.current.userInterfaceIdiom == .pad && SCREEN_MAX_LENGTH == 1366.0

let FONT_BOLD = "OpenSans-Regular"
let FONT_LIGHT = "Montserrat-Regular"
let FONT_REGULAR = "ProximaNova-Regular"
let FONT_SEMIBOLD = "ProximaNova-Semibold"

let PINK = UIColor(red: (226.0/255.0), green: (34.0/255.0), blue: (164.0/255.0), alpha: 1.0)
let PINK_LIGHT = UIColor(red: (235.0/255.0), green: (154.0/255.0), blue: (224.0/255.0), alpha: 1.0)
let GREY_BG = UIColor(red: (244.0/255.0), green: (246.0/255.0), blue: (249.0/255.0), alpha: 1.0)
let BLUE = UIColor(red: (8.0/255.0), green: (74.0/255.0), blue: (136.0/255.0), alpha: 1.0)

let WebserviceBaseURL = ""

func getUserDefaultObjectForKey(key: String) -> AnyObject!
{
    var retVal : AnyObject!;
    let prefs = UserDefaults.standard as UserDefaults
    retVal = prefs.object(forKey: key) as AnyObject
    return retVal
}

extension UIImage
{
    // MARK: - UIImage+Resize
    func compressImage (_ image: UIImage) -> UIImage
    {
        let actualHeight:CGFloat = image.size.height
        let actualWidth:CGFloat = image.size.width
        let imgRatio:CGFloat = actualWidth/actualHeight
        let maxWidth:CGFloat = 1024.0
        let resizedHeight:CGFloat = maxWidth/imgRatio
        let compressionQuality:CGFloat = 0.5
        
        let rect:CGRect = CGRect(x: 0, y: 0, width: maxWidth, height: resizedHeight)
        UIGraphicsBeginImageContext(rect.size)
        image.draw(in: rect)
        let img: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        let imageData:Data = UIImageJPEGRepresentation(img, compressionQuality)!
        UIGraphicsEndImageContext()
        
        return UIImage(data: imageData)!
    }
}
