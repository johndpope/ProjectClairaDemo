//
//  LoginSignupDashboardVC.swift
//  ClairaBellaDemo
//
//  Created by Vikash Kumar on 11/01/18.
//  Copyright © 2018 Vikash Kumar. All rights reserved.
//

import UIKit
import AWSCognitoIdentityProvider

class LoginSignupDashboardVC: ParentVC {

    var passwordAuthenticationCompletion: AWSTaskCompletionSource<AWSCognitoIdentityPasswordAuthenticationDetails>?
    var usernameText: String?
    let progressHUD = ProgressView(text: "Please Wait")

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LoginSegue" {
            let loginVC = segue.destination as! LoginVC
            loginVC.delegate = self
        }
    }
}

extension LoginSignupDashboardVC: LoginVCDelegate {
    func loginWith(email: String, password: String) {
        progressHUD.show()
        
        let authDetails = AWSCognitoIdentityPasswordAuthenticationDetails(username: email, password: password )
        self.passwordAuthenticationCompletion?.set(result: authDetails)

    }
}


extension LoginSignupDashboardVC: AWSCognitoIdentityPasswordAuthentication {
    
    public func getDetails(_ authenticationInput: AWSCognitoIdentityPasswordAuthenticationInput, passwordAuthenticationCompletionSource: AWSTaskCompletionSource<AWSCognitoIdentityPasswordAuthenticationDetails>) {
        self.passwordAuthenticationCompletion = passwordAuthenticationCompletionSource
        DispatchQueue.main.async {
            if (self.usernameText == nil) {
                self.usernameText = authenticationInput.lastKnownUsername
            }
        }
    }
    
    public func didCompleteStepWithError(_ error: Error?) {
        DispatchQueue.main.async {
            self.progressHUD.hide()
            if let error = error as NSError? {
                let alertController = UIAlertController(title: error.userInfo["__type"] as? String,
                                                        message: error.userInfo["message"] as? String,
                                                        preferredStyle: .alert)
                let retryAction = UIAlertAction(title: "Retry", style: .default, handler: nil)
                alertController.addAction(retryAction)
                
                self.present(alertController, animated: true, completion:  nil)
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
}
