//
//  AuthenticationViewController.swift
//  ClairaBellaDemo
//
//  Created by Vikash Kumar on 16/01/18.
//  Copyright © 2018 Vikash Kumar. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import AWSCognitoIdentityProvider
import AWSCognito
import UICKeyChainStore


let COGNITO_FB_PROVIDER = "graph.facebook.com"

let cognitoSyncKey = "cognitoSync"
let AmazonClientManagerDidLogoutNotification = Notification.Name("AmazonClientManagerDidLogoutNotification")
let KEYCHAIN_PROVIDER_KEY = "KEYCHAIN_PROVIDER_KEY"

class AuthenticationViewController: ParentVC {

    let viewModel = LoginViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.onDone = {[unowned self] in
            self.hideHud()
            appDelegate.fetchUserDetails()
            appDelegate.getCharactersFromServer()
            //self.performSegue(withIdentifier: "goToHome", sender: nil)
        }
        
        viewModel.onError = {[unowned self] error in
            self.hideHud()
            AmazonClientManager.shared.logOut()
        }
        

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(self.navigateToHome), name: NSNotification.Name(rawValue: "CharactersLoadingFinish"), object: nil)

    }

    @IBAction func Btn_Facebook_Login(_ sender: UIButton) {
        facebookLogin()
    }
    
    
    
    //MARK:- Login/Signup(Form and Facebook) on AWS Coginito Server.
    
    func facebookLogin() {
        if FBSDKAccessToken.current() != nil {
            //For debugging, when we want to ensure that facebook login always happens
            FBSDKLoginManager().logOut()
        }
        
        let facebookReadPermissions = ["public_profile", "email"]

        FBSDKLoginManager().logIn(withReadPermissions: facebookReadPermissions, from: self) { (result, error) in
            if result?.isCancelled == false {
                guard let token = result?.token.tokenString, error == nil else {
                    // Handle cancellations
                    FBSDKLoginManager().logOut()
                    
                    //show error UI
                    return
                }

                self.showHud()
                self.viewModel.login(fbToken: token)

            }
            
        }

    }
    
    func login(username: String, email: String, password: String, fbLogin: Bool = false, block: ((Bool)->Void)? = nil) {
        
        appDelegate.currentUser = appDelegate.pool?.getUser(username)
        
        appDelegate.currentUser?.getSession(email, password: password, validationData: nil).continueWith(executor: AWSExecutor.mainThread(), block: { (task) -> Any? in
            self.hideHud()
            
            if let error = task.error as? NSError {
                if !fbLogin {
                    self.showAlert(message: (error.userInfo["message"] as? String) ?? "")
                }
                block?(false)
            } else {
                //
                
                let result = ["email": email, "password": password, "isFacebookLogin" : fbLogin] as [String : Any]
                UserDefaults(suiteName: appGroupName)!.setValue(result, forKey: UserAttributeKey.loggedInUserKey)
                
                appDelegate.fetchUserDetails()
                appDelegate.getCharactersFromServer()
                //self.performSegue(withIdentifier: "goToHome", sender: nil)
                
                block?(true)
            }
            return nil
            
        })
        
    }
    
    
    
    func signup(username: String,  password: String, email: String, name: String,  fbLogin: Bool = false, block: ((Bool)->Void)? = nil) {
        let emailAtt = AWSCognitoIdentityUserAttributeType()
        emailAtt?.name = UserAttributeKey.email
        emailAtt?.value = email
        
        let nameAtt = AWSCognitoIdentityUserAttributeType()
        nameAtt?.name = UserAttributeKey.name
        nameAtt?.value = name
        
        
        let dobAtt = AWSCognitoIdentityUserAttributeType()
        dobAtt?.name = UserAttributeKey.birthdate
        dobAtt?.value = "00-00-0000"
        
        
        //sign up the user
        appDelegate.pool?.signUp(email, password: password, userAttributes: [emailAtt!, nameAtt!, dobAtt!], validationData: nil).continueWith {[weak self] (task) -> Any? in
            guard let strongSelf = self else { return nil }
            
            DispatchQueue.main.async(execute: {
                
                if let error = task.error as NSError? {
                    block?(false)
                    let alertController = UIAlertController(title: error.userInfo["__type"] as? String,
                                                            message: error.userInfo["message"] as? String,
                                                            preferredStyle: .alert)
                    let retryAction = UIAlertAction(title: "Retry", style: .default, handler: nil)
                    alertController.addAction(retryAction)
                    
                    self?.present(alertController, animated: true, completion:  nil)
                } else if let result = task.result  {
                    // handle the case where user has to confirm his identity via email / SMS
                    if (result.user.confirmedStatus != AWSCognitoIdentityUserStatus.confirmed) {
                        appDelegate.currentUser = task.result?.user
                        //strongSelf.sentTo = result.codeDeliveryDetails?.destination
                        
                        strongSelf.performSegue(withIdentifier: "confirmSignUpSegue", sender:nil)
                    } else {
                        let _ = strongSelf.navigationController?.popToRootViewController(animated: true)
                    }
                    
                    block?(true)

                }
                
            })
            return nil
        }
        
    }
    
    
    
    //MARK:- Form Login and Singup with on Client's Server
    
    func login(email: String, password: String, block:@escaping (Bool)->Void) {
        let params = ["password_attempt" : password]

        APICall.shared.loginUser_APICall(email: email, params: params, block: { (response,success) in
            if success {
                if let json = response as? [String : Any], let userInfo = json["success"] as? [String : String] {
                    
                    let firstName = userInfo["first_name"] ?? ""
                    let lastName = userInfo["Last_name"] ?? ""
                    let name = firstName + " " + lastName
                    let dob = userInfo["date_of_birth"] ?? ""
                    
                    let result = [UserAttributeKey.email: email,
                                  UserAttributeKey.name: name,
                                  UserAttributeKey.firstname: firstName,
                                  UserAttributeKey.lastname : lastName,
                                  UserAttributeKey.birthdate : dob]
                    
                    UserDefaults(suiteName: appGroupName)!.setValue(result, forKey: UserAttributeKey.loggedInUserKey)
                    appDelegate.getCharactersFromServer()
                    
                    block(true)

                } else  {
                    print("Email and password is wrong.")
                    block(false)
                    
                }
                
            } else {
            }
            
            self.hideHud()
        })

    }
    
    func signup(email: String, params: [String : String]) {
        

        APICall.shared.signupUser_APICall(email: email, params: params) { (response,success) in
            if success {
                let firstName = params["first_name"]!
                let lastName = params["Last_name"]!
                let name = firstName + " " + lastName
                
                let result = [UserAttributeKey.email: email,
                              UserAttributeKey.name: name,
                              UserAttributeKey.firstname: firstName,
                              UserAttributeKey.lastname : lastName,
                              UserAttributeKey.birthdate : ""]
                
                UserDefaults(suiteName: appGroupName)!.setValue(result, forKey: UserAttributeKey.loggedInUserKey)
                appDelegate.getCharactersFromServer()
            } else {
            }
            self.hideHud()
        }
    }

    
    func navigateToHome() {
            self.hideHud()
        
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if Character.myCharacters.isEmpty {
                
                //present Create character screen over Home screen if user dont have create any character yet.

                let homeVC = storyboard.instantiateViewController(withIdentifier: "mainTabVC") as! UITabBarController
                let viewController = storyboard.instantiateViewController(withIdentifier: "CharBuilderNavVC") as! UINavigationController
                
                self.navigationController?.present(viewController, animated: true, completion: {
                    self.navigationController?.viewControllers = [homeVC]
                })
            } else {
//                self.btn_pressed.sendActions(for: .touchUpInside)
                self.performSegue(withIdentifier: "goToHome", sender: nil)

            }
        }
}







class CustomIdentityProvider: NSObject, AWSIdentityProviderManager {
    var tokens: [String : String]?
    
    init(tokens: [String : String]?) {
        self.tokens = tokens
    }
    
    /**
     Each entry in logins represents a single login with an identity provider.
     The key is the domain of the login provider (e.g. 'graph.facebook.com')
     and the value is the OAuth/OpenId Connect token that results from an authentication with that login provider.
     */
    func logins() -> AWSTask<NSDictionary> {
        let logins: NSDictionary = NSDictionary(dictionary: tokens ?? [:])
        return AWSTask(result: logins)
    }
}


class FBSessionProvider: AmazonSessionProvider {
    private let keyChain: UICKeyChainStore
    
    init() {
        keyChain = UICKeyChainStore(service: Bundle.main.bundleIdentifier!)
    }
    
    func getSessionTokens(completition: @escaping (([String : String]?, Error?) -> ())) {
        guard FBSDKAccessToken.current() != nil else {
            completition(nil, AmazonSessionProviderErrors.LoginFailed)
            return
        }
        keyChain[KEYCHAIN_PROVIDER_KEY] = AmazonSessionProviderType.FB.rawValue
        completition([COGNITO_FB_PROVIDER : FBSDKAccessToken.current().tokenString], nil)
    }
    
    func isLoggedIn() -> Bool {
        return FBSDKAccessToken.current() != nil
    }
    
    func logout() {
        FBSDKLoginManager().logOut()
    }
}


enum AmazonSessionProviderErrors: Error {
    case RestoreSessionFailed
    case LoginFailed
}

extension Error {
    var infoMessage: String? {
        return (self as NSError).userInfo["message"] as? String
    }
}

protocol AmazonSessionProvider {
    /**
     Each entry in logins represents a single login with an identity provider.
     The key is the domain of the login provider (e.g. 'graph.facebook.com')
     and the value is the OAuth/OpenId Connect token that results from an authentication with that login provider.
     */
    func getSessionTokens(completition: @escaping (([String : String]?, Error?) -> ()))
    func isLoggedIn() -> Bool
    func logout()
}



enum AmazonSessionProviderType: String {
    case FB, USERPOOL
}




typealias AmazonClientCompletition = ((Error?) -> ())

final class AmazonClientManager {
    static let shared = AmazonClientManager()
    
    private let keyChain: UICKeyChainStore
    private var credentialsProvider: AWSCognitoCredentialsProvider?
    private var sessionProvider: AmazonSessionProvider?
    private let customIdentityProvider: CustomIdentityProvider
    
    var currentIdentity: String? {
        return credentialsProvider?.identityId
    }
    
    init() {
        keyChain = UICKeyChainStore(service: Bundle.main.bundleIdentifier!)
        self.customIdentityProvider = CustomIdentityProvider(tokens: nil)
        #if DEBUG
            AWSLogger.default().logLevel = .verbose
        #endif
        // Check if we have session indicator stored
        
        sessionProvider = FBSessionProvider()
    }
    
    // Tries to initiate a session with given session provider returns an error otherwise
    func login(sessionProvider: AmazonSessionProvider, completion: AmazonClientCompletition?) {
        self.sessionProvider = sessionProvider
        self.resumeSession(completion: completion)
    }
    
    // Tries to restore session or returns an error
    func resumeSession(completion: AmazonClientCompletition?) {
        if let sessionProvider = sessionProvider {
            sessionProvider.getSessionTokens() { [unowned self] (tokens, error) in
                guard let tokens = tokens, error == nil else {
                    completion?(error)
                    return
                }
                self.completeLogin(logins: tokens, completition: completion)
            }
        } else {
            completion?(AmazonSessionProviderErrors.RestoreSessionFailed)
        }
    }
    
    // Removes all associated session and cleans keychain
    func clearAll() {
        let cognito = AWSCognito(forKey: cognitoSyncKey)
        cognito.wipe()
        
        sessionProvider?.logout()
        keyChain.removeAllItems()
        credentialsProvider?.clearKeychain()
        credentialsProvider?.clearCredentials()
        sessionProvider = nil
        customIdentityProvider.tokens = nil
    }
    
    func logOut() {
        clearAll()
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: AmazonClientManagerDidLogoutNotification, object: nil)
        }
    }
    
    // Checks if we have logged in before
    func isLoggedIn() -> Bool {
        return sessionProvider?.isLoggedIn() ?? false
    }
    
    private func completeLogin(logins: [String : String]?, completition: AmazonClientCompletition?) {
        // Here we setup our default configuration with Credentials Provider, which uses our custom Identity Provider
        customIdentityProvider.tokens = logins
        
        self.credentialsProvider = AWSCognitoCredentialsProvider(regionType: CognitoIdentityUserPoolRegion,
                                                                 identityPoolId: "eu-west-2:68cdd82b-33c1-4047-9b8d-e63ba946e0b2",
                                                                 identityProviderManager: customIdentityProvider)
        
        self.credentialsProvider?.getIdentityId().continueWith(block:{ (task) in
            if (task.error != nil) {
                completition?(task.error)
            } else {
                let configuration = AWSServiceConfiguration(region: CognitoIdentityUserPoolRegion,
                                                            credentialsProvider: self.credentialsProvider)
                
                // Save confuguration as default for all AWS services
                // It can be set only once, any subsequent setters are ignored.
                AWSServiceManager.default().defaultServiceConfiguration = configuration
                AWSCognito.register(with: configuration!, forKey: cognitoSyncKey)
                
                completition?(nil)
            }
            return task
        })
    }
}


final class LoginViewModel {
    var isLoading: ((Bool) -> ())?
    var onError: ((String) -> ())?
    var onDone: (() -> ())?
    
    init() {
    }
    
//    func login(email: String, password: String) {
//        guard !email.isEmpty && !password.isEmpty else {
//            onError?("All fields are required.")
//            return
//        }
//        let sessionProvider = LoginUserPoolSessionProvider(username: email, password: password)
//        AmazonClientManager.shared.login(sessionProvider: sessionProvider) { [unowned self] (error) in
//            guard error == nil else {
//                AmazonClientManager.shared.clearAll()
//                DispatchQueue.main.async { [weak self] in
//                    self?.onError?(error?.infoMessage ?? "Failed to login")
//                }
//                return
//            }
//            self.onDone?()
//        }
//    }
    
    func login(fbToken: String) {
        isLoading?(true)
        let params = ["fields": "id, email, first_name, last_name, name"]
        let sessionProvider = FBSessionProvider()
        AmazonClientManager.shared.login(sessionProvider: sessionProvider) { [unowned self] (error) in
            guard error == nil else {
                AmazonClientManager.shared.clearAll()
                DispatchQueue.main.async { [weak self] in
                    self?.onError?(error?.infoMessage ?? "Failed to login with Facebook")
                }
                return
            }
            
            CognitoUser.sync() { [unowned self] _ in
                let user = CognitoUser.currentUser()
                if user.name == nil || user.email == nil {
                    // Fetch basic info from Facebook, e.g. first and last name
                    executeFBRequest(path: "me", params: params) { (data, error) in
                        if error != nil {
                            DispatchQueue.main.async { [weak self] in
                                self?.onError?(error?.infoMessage ?? "Failed to login with Facebook")
                            }
                        }
                        user.name = data?["name"] as? String
                        user.birthDate = "00-00-0000"
                        user.email = data?["email"] as? String
                        // Save info and proceed
                        user.save() { (done) in
                            guard done == true else {
                                DispatchQueue.main.async { [weak self] in
                                    self?.onError?("Failed to login with Facebook")
                                }
                                return
                            }
                            self.onDone?()
                        }
                    }
                } else {
                    self.onDone?()
                }
            }
            
        }
    }
}




internal let cognitoSyncDataset = "userProfile"

final class CognitoUser {
    var userId: String?
    var email: String?
    var name: String?
    var birthDate: String?
    
    init() {
        userId = NSUUID().uuidString
    }
}

extension CognitoUser {
    // Save all user's data to CognitoSync
    func save(completition: @escaping ((Bool) -> ())) {
        // openOrCreateDataset - creates a dataset if it doesn't exists or open existing
        let dataset = AWSCognito(forKey: cognitoSyncKey).openOrCreateDataset(cognitoSyncDataset)
        dataset.setString(name, forKey: "given_name")
        dataset.setString(birthDate, forKey: "birthdate")
        dataset.setString(email, forKey: "email")
        CognitoUser.sync(completition: completition)
    }
    
    static func sync(completition: @escaping ((Bool) -> ())) {
        // openOrCreateDataset - creates a dataset if it doesn't exists or open existing
        let dataset = AWSCognito(forKey: cognitoSyncKey).openOrCreateDataset(cognitoSyncDataset)
        // synchronize is going to:
        // 1) Fetch from AWS, if there were any changes
        // 2) Upload local changes to AWS
        dataset.synchronize().continueWith(block: { (task) in
            DispatchQueue.main.async { completition(task.error == nil) }
            return nil
        })
    }
    
    static func currentUser(firstName: String? = nil, lastName: String? = nil) -> CognitoUser {
        let dataset = AWSCognito(forKey: cognitoSyncKey).openOrCreateDataset(cognitoSyncDataset)
        let user = CognitoUser()
        user.userId = dataset.string(forKey: "userId") ?? NSUUID().uuidString
        user.name = dataset.string(forKey:"given_name")
        user.birthDate = dataset.string(forKey:"birthdate")
        user.email = dataset.string(forKey:"email")
        return user
    }
}


/**
 Executes one Facebook Graph request
 - path: a graph path for request
 - params: optional params to send with request
 - returns: Observable with DataProviderResult, in case of success the data is a dictionary
 */
func executeFBRequest(path: String, params: [String : String]?, completition: (([String:AnyObject]?, Error?) -> ())?){
    let graphRequest: FBSDKGraphRequest = FBSDKGraphRequest(graphPath: path, parameters: params)
    _ = graphRequest.start {(connection, result, error) -> Void in
        completition?(result as? [String:AnyObject], error)
    }
}


