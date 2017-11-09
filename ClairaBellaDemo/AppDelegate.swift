//
//  AppDelegate.swift
//  ClairaBellaDemo
//
//  Created by Vikash Kumar on 17/08/17.
//  Copyright © 2017 Vikash Kumar. All rights reserved.
//

import UIKit
import CoreData
import FBSDKCoreKit
import CloudKit

let appDelegate = UIApplication.shared.delegate as! AppDelegate

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        CharacterHTMLBuilder.shared.loadBuildData()
        self.setTabbarAppearance()
        self.getCharactersFromServer()
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)

       
        return true
    }

    func setTabbarAppearance() {
        UITabBar.appearance().tintColor = UIColor(red: 225.0/255.0, green: 57.0/255.0, blue: 169.0/255.0, alpha: 1.0)
        
        UITabBarItem.appearance().badgeColor = UIColor(red: 74.0/255.0, green: 144.0/255.0, blue: 226.0/255.0, alpha: 1.0)
        
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName:UIColor(red: 225.0/255.0, green: 57.0/255.0, blue: 169.0/255.0, alpha: 1.0)], for: .selected)
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.lightGray], for: .normal)

    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        FBSDKAppEvents.activateApp()
    }

    
    
    //Facebook Delegate Methods
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(app, open: url, options: options)
    }

    
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "ClairaBella")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }


}

extension AppDelegate {
    func getCharactersFromServer() {
        
        self.loadCharactersFromPlist()
        
        APICall.shared.getSavedCharaters_APICall() { (response, success) in
            if success {
                print(response!)
                if let jsonArr = response as? [[String : Any]] {
                    let charters = jsonArr.map({ (json) -> Character in
                        let choice = json["choices"] as! [String : String]
                        let character = Character()
                        character.choices = choice
                        character.createdDate = json["date_created"] as! String
                        character.name = json["saved_name"] as! String
                        if let meta = json["meta"] as? [String : Any] {
                            character.alive = meta["alive"] as! Bool
                        }
                        return character
                    })
                    
                    Character.myCharacters = charters.filter({$0.alive})
                    print("CharactersLoadingFinish")
                    
                    self.saveCharacterInToLocalFile(json: jsonArr)
                }
                
            } else {
                
            }
            DispatchQueue.main.async {
                Character.loadingFinish = true
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CharactersLoadingFinish"), object: nil)
            }

        }
    }
    
    func saveCharacterInToLocalFile(json: Any) {
        let filePath =  NSHomeDirectory()+"/Documents/Characters.plist"
        let fileManager = FileManager.default
        
        if !fileManager.fileExists(atPath: filePath) {
            if let bundlePath = Bundle.main.path(forResource: "UsersCharacters", ofType: "plist") {
                do {
                    try fileManager.copyItem(atPath: bundlePath, toPath: filePath)
                    
                } catch {
                    return
                }
            }
        }
        
        let characterDic = NSMutableDictionary(contentsOfFile: filePath)
        characterDic?["Characters"] = json
        characterDic?.write(toFile: filePath, atomically: true)
        
    }
    
    func loadCharactersFromPlist() {
        let filePath =  NSHomeDirectory()+"/Documents/Characters.plist"
        
        if let charactersDic = NSMutableDictionary(contentsOfFile: filePath) {
            if let charactersArr = charactersDic["Characters"] as? [[String : Any]] {
                let charters = charactersArr.map({ (json) -> Character in
                    let choice = json["choices"] as! [String : String]
                    let character = Character()
                    character.choices = choice
                    character.createdDate = json["date_created"] as! String
                    character.name = json["saved_name"] as! String
                    if let meta = json["meta"] as? [String : Any] {
                        character.alive = meta["alive"] as! Bool
                    }
                    return character
                })
                
                Character.myCharacters = charters.filter({$0.alive})
            }
        }

    }
}

