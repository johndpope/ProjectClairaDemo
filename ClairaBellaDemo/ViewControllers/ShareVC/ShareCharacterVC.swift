//
//  ShareCharacterVC.swift
//  ClairaBellaDemo
//
//  Created by Vikash Kumar on 21/09/17.
//  Copyright © 2017 Vikash Kumar. All rights reserved.
//

import UIKit
import Social

class ShareCharacterVC: ParentVC {
    @IBOutlet var webview: UIWebView!
    @IBOutlet var collView: UICollectionView!
    @IBOutlet var indicator: IndicatorView!
    @IBOutlet var backImageView: UIImageView!
    
    var character: Character!
    
    var backgrounds = [CharBackground]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collView.contentInset = UIEdgeInsetsMake(8, 8, 8, 8)
        loadBackgroundImages()
        
        CharacterHTMLBuilder.shared.buildCharHTMLWith(choices: character.choices, block: { html in
            self.webview.loadHTMLString(html, baseURL: nil)
        })

    }
    
    func loadBackgroundImages() {
        
        var noneBack = CharBackground()
        noneBack.icon = "Background_none"
        self.backgrounds.append(noneBack)
        
        (1...23).forEach { index in
            let iconName = "background_small\(index).jpg"
            let imgName = "background\(index).jpg"
            var back = CharBackground()
            back.icon = iconName
            back.image = imgName
            
            self.backgrounds.append(back)
            
        }
    }

}

extension ShareCharacterVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return backgrounds.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
       
        let back = backgrounds[indexPath.row]
        cell.imgView.image = UIImage(named: back.icon)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 40)/4
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let back = self.backgrounds[indexPath.row]
        backImageView.image = UIImage(named: back.image)
        character.characterBackground = back
    }
    
}

extension ShareCharacterVC {
    @IBAction func share_btnClicekd(_ sender:UIButton) {
        ShareCharacterView.show(in: self.view, character: character) { (action, image) in
            switch action {
            case .facebook:
                self.shareOnFacebook(image)
            case .twitter:
                print("twitter")
                self.shareOnTwitter(image)
            case .mail:
                print("mail")
            case .save:
                print("save")
            case .more:
                print("more")
            }
        }
    }
    
    
    func shareOnFacebook(_ image: UIImage) {
        if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeFacebook) {
            let vc = SLComposeViewController(forServiceType:SLServiceTypeFacebook)!
            vc.add(image)
            //        vc.add(URL(string: "http://www.example.com/"))
            //        vc.setInitialText("Initial text here.")

            self.present(vc, animated: true, completion: nil)
        } else {
            showAlert(message: "Please go to settings > Facebook and add your facebook account. ")
        }
    }

    
    func shareOnTwitter(_ image: UIImage) {
        if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter) {
            let vc = SLComposeViewController(forServiceType:SLServiceTypeTwitter)!
            vc.add(image)
            //        vc.add(URL(string: "http://www.example.com/"))
            //        vc.setInitialText("Initial text here.")
            
            self.present(vc, animated: true, completion: nil)
        } else {
            showAlert(message: "Please go to settings > Twitter and add your twitter account. ")
        }
    }

}



extension UIViewController {
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Claireabella", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}
