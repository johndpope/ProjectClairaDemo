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
import Fabric
import Crashlytics
import IQKeyboardManager
import Alamofire
import SSZipArchive
import TwitterKit
import AWSCognitoIdentityProvider

let appDelegate = UIApplication.shared.delegate as! AppDelegate

let CognitoIdentityUserPoolRegion           = AWSRegionType.EUWest2
let CognitoIdentityUserPoolId               = "eu-west-2_VAAFw8nyX"
let CognitoIdentityUserPoolAppClientId      = "3laqjoj4llcglpdmjivtk96s5c"
let CognitoIdentityUserPoolAppClientSecret  = "1l19vvcid4sbcgj8g51f0asc6t1ken6il5caup9g71qqdtkidm6u"

let AWSCognitoUserPoolsSignInProviderKey = "UserPool"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var loginVC: LoginSignupDashboardVC?
    var mfaViewController: MFAViewControllerVC?
    var navigationController: UINavigationController?
    var storyboard = UIStoryboard(name: "WalkThrough", bundle: nil)

    var rememberDeviceCompletionSource: AWSTaskCompletionSource<NSNumber>?
    var pool:AWSCognitoIdentityUserPool?

    var mainTabbarController: UITabBarController? {
        if let childViewControlelrs = self.window?.rootViewController?.childViewControllers {
            for vc in childViewControlelrs {
                if vc is UITabBarController {
                    return vc as? UITabBarController
                }
            }
        }
        return nil
    }
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
       
        
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)

        Fabric.with([Crashlytics.self])
        IQKeyboardManager.shared().isEnabled = true

        //API calls: Call api for Get all character.
        //Call api for Getting character builder json
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        self.getCharactersFromServer()
        CharacterHTMLBuilder.shared.loadBuildData { (success) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
        
        checkAndDownloadNewAssetsIfAvailable()
        //UserDefaults.standard.removeObject(forKey: "AssetVersion")
        
        Twitter.sharedInstance().start(withConsumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
       
        //configure AWS Cognito Auth
        self.awsConfiguration()
        
        

        return true
    }

    
    

    func awsConfiguration() {
        // setup logging
        //AWSDDLog.sharedInstance.logLevel = .verbose
        
        // setup service configuration
        let serviceConfiguration = AWSServiceConfiguration(region: CognitoIdentityUserPoolRegion, credentialsProvider: nil)
        
        // create pool configuration
        let poolConfiguration = AWSCognitoIdentityUserPoolConfiguration(clientId: CognitoIdentityUserPoolAppClientId,
                                                                        clientSecret: CognitoIdentityUserPoolAppClientSecret,
                                                                        poolId: CognitoIdentityUserPoolId)
        
        // initialize user pool client
        AWSCognitoIdentityUserPool.register(with: serviceConfiguration, userPoolConfiguration: poolConfiguration, forKey: AWSCognitoUserPoolsSignInProviderKey)
        
        pool = AWSCognitoIdentityUserPool(forKey: AWSCognitoUserPoolsSignInProviderKey)
        // fetch the user pool client we initialized in above step
       // pool.delegate = self

    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        FBSDKAppEvents.activateApp()
    }

    
    
    //Facebook Delegate Methods
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        let directedByTWTR =  Twitter.sharedInstance().application(app, open: url, options: options)
        let directedByFacebook = FBSDKApplicationDelegate.sharedInstance().application(app, open: url, options: options)
        return directedByTWTR || directedByFacebook
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
                    
                    let chars = charters.filter({$0.alive})
                    Character.myCharacters =  self.sortCharacters(chars: chars)
                    print("CharactersLoadingFinish")
                    
                    self.saveCharacterInToLocalFile(json: jsonArr)
                } else {
                    Character.myCharacters = []
                }
                
            } else {
                Character.myCharacters = []

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
                
                let chars = charters.filter({$0.alive})
                
                Character.myCharacters = sortCharacters(chars: chars)
            }
        }

    }
    
    func sortCharacters(chars: [Character])-> [Character] {
        var characters = chars
        characters.sort { (ch1, ch2) -> Bool in
            return ch1.createdDate < ch2.createdDate
        }
        
        let temp = chars
        
        for (index, ch) in temp.enumerated() {
            if ch.isMainChar {
                characters.remove(at: index)
                characters.insert(ch, at: 0)
            }
        }
        return characters
    }

}


extension AppDelegate {
    //Download new character and interface assets with latest version
    
    func checkAndDownloadNewAssetsIfAvailable() {
        CharBuilderAPI.shared.getInterface_json { menu in
            //
        }
    }
    
    func downloadNewAssets(completion callBack: @escaping (Bool, Double)->Void) {
        
        if let url = URL(string: APICall.APIName.characterAssetsDownload) {
            let destination: DownloadRequest.DownloadFileDestination = {_,  _ in
                let savePathURL = documetDirectoryURL().appendingPathComponent("characterImages.zip")
                return (savePathURL, [.removePreviousFile])
            }
            
            Alamofire.download(url,
                               method: .get,
                               parameters: nil,
                               encoding: JSONEncoding.default,
                               headers: nil, to: destination).downloadProgress(closure: { (progress) in
                                //show progress
                                print(progress.fractionCompleted)
                                callBack(false, progress.fractionCompleted)
                                
                               }).response(completionHandler: { (response) in
                                //download completed
                                if let url = response.destinationURL {
                                    let unZipPath = documetDirectoryURL().appendingPathComponent("/CharacterAssets/Version").path
                                    let success = self.unzipFile(at: url.path, to: unZipPath)
                                    callBack(success, 1.0)
                                    NotificationCenter.default.post(name: Notification.Name(rawValue: "CharactersLoadingFinish"), object: nil)
                                }
                               })
            
        }
        
    }
    
    
    
    
    //UNZip assets
    func unzipFile(at sourcePath: String, to destinationPath: String)-> Bool {
        let success = SSZipArchive.unzipFile(atPath: sourcePath, toDestination: destinationPath)
        let message = success ? "Success" : "Fail"
        print(message)
        return success
    }


}


// MARK:- AWSCognitoIdentityInteractiveAuthenticationDelegate protocol delegate

extension AppDelegate: AWSCognitoIdentityInteractiveAuthenticationDelegate {
    
    func startPasswordAuthentication() -> AWSCognitoIdentityPasswordAuthentication {
        if (self.navigationController == nil) {
            self.navigationController = UINavigationController()
            self.navigationController?.isNavigationBarHidden = true
        }
        
        if (self.loginVC == nil) { //LoginVC
            let loginBoardScreen = self.storyboard.instantiateViewController(withIdentifier: "LoginDashboard") as! LoginSignupDashboardVC

            self.loginVC = loginBoardScreen
            self.navigationController?.viewControllers = [loginBoardScreen]
        }
        
        DispatchQueue.main.async {
            self.navigationController!.popToRootViewController(animated: true)
            if (!self.navigationController!.isViewLoaded
                || self.navigationController!.view.window == nil) {
                self.window?.rootViewController?.present(self.navigationController!,
                                                         animated: true,
                                                         completion: nil)
            }
            
        }
        return self.loginVC!
    }
    
    func startMultiFactorAuthentication() -> AWSCognitoIdentityMultiFactorAuthentication {
        if (self.mfaViewController == nil) {
            self.mfaViewController = self.storyboard.instantiateViewController(withIdentifier: "MFAViewControllerVC") as! MFAViewControllerVC
            self.mfaViewController?.modalPresentationStyle = .popover
        }
        
        DispatchQueue.main.async {
            if (!self.mfaViewController!.isViewLoaded
                || self.mfaViewController!.view.window == nil) {
               
                //display mfa as popover on current view controller
                let viewController = self.window?.rootViewController!
                viewController?.present(self.mfaViewController!,
                                        animated: true,
                                        completion: nil)
                
                // configure popover vc
                let presentationController = self.mfaViewController!.popoverPresentationController
                presentationController?.permittedArrowDirections = UIPopoverArrowDirection.left
                presentationController?.sourceView = viewController!.view
                presentationController?.sourceRect = viewController!.view.bounds
            }
        }
        return self.mfaViewController!
    }
    
    func startRememberDevice() -> AWSCognitoIdentityRememberDevice {
        return self
    }
}



// MARK:- AWSCognitoIdentityRememberDevice protocol delegate

extension AppDelegate: AWSCognitoIdentityRememberDevice {
    
    func getRememberDevice(_ rememberDeviceCompletionSource: AWSTaskCompletionSource<NSNumber>) {
        //self.rememberDeviceCompletionSource = rememberDeviceCompletionSource
        DispatchQueue.main.async {
            // dismiss the view controller being present before asking to remember device
            self.window?.rootViewController!.presentedViewController?.dismiss(animated: true, completion: nil)
            let alertController = UIAlertController(title: "Remember Device",
                                                    message: "Do you want to remember this device?.",
                                                    preferredStyle: .actionSheet)
            
            let yesAction = UIAlertAction(title: "Yes", style: .default, handler: { (action) in
               self.rememberDeviceCompletionSource?.set(result: true)
            })
            let noAction = UIAlertAction(title: "No", style: .default, handler: { (action) in
                self.rememberDeviceCompletionSource?.set(result: false)
            })
            alertController.addAction(yesAction)
            alertController.addAction(noAction)
            
            self.window?.rootViewController?.present(alertController, animated: true, completion: nil)
        }
    }
    
    func didCompleteStepWithError(_ error: Error?) {
        DispatchQueue.main.async {
            if let error = error as NSError? {
                let alertController = UIAlertController(title: error.userInfo["__type"] as? String,
                                                        message: error.userInfo["message"] as? String,
                                                        preferredStyle: .alert)
                let okAction = UIAlertAction(title: "ok", style: .default, handler: nil)
                alertController.addAction(okAction)
                DispatchQueue.main.async {
                    self.window?.rootViewController?.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
}

