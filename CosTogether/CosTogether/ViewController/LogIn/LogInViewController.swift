//
//  LogInViewController.swift
//  CosTogether
//
//  Created by George Liu on 2018/9/19.
//  Copyright © 2018 George Liu. All rights reserved.
//

import UIKit
import KeychainAccess
import SVProgressHUD

class LogInViewController: UIViewController {

    @IBOutlet weak var facebookLoginBot: UIButton!
    @IBOutlet weak var anonymousLogInBot: UIButton!
    
    private let fbManager = FacebookManager()
    private let firebaseManager = FirebaseManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setImage()
        
    }
    
    private func setImage() {
        
        facebookLoginBot.layer.cornerRadius = 10
        anonymousLogInBot.layer.cornerRadius = 10
        
    }
    
    @IBAction func logInFB(_ sender: UIButton) {
        
        if let alertController = Reachability.connectionWarning() {
            
            present(alertController, animated: true, completion: nil)

        } else {
            
            fbManager.facebookLogIn(
                fromController: self,
                sucess: { [weak self] (token) in
                    
                    self?.signInFirebase(token: token)
                    
            },
                failure: { [weak self] (error) in
                    
                    SVProgressHUD.dismiss()
                    
                    guard let error = error as? FBError else {
                        return
                    }
                    
                    self?.present(
                        UIAlertController.errorMessage(errorType: error),
                        animated: true,
                        completion: nil
                    )
                    
            })
        }
    }
    
    private func signInFirebase(token: String) {
        
        if let alertController = Reachability.connectionWarning() {
            
            present(alertController, animated: true, completion: nil)
            
        } else {
            
            firebaseManager.logInFirebase(
                token: token,
                success: {
                    
                    DispatchQueue.main.async {
                        AppDelegate.shared.switchMainPage()
                    }
                    
                    SVProgressHUD.dismiss()
                    
            },
                failure: { [weak self ] (error) in
                    
                    SVProgressHUD.dismiss()

                    guard let error = error as? FBError else {
                        
                        return
                        
                    }
                    
                    self?.present(
                        UIAlertController.errorMessage(errorType: error),
                        animated: true,
                        completion: nil
                    )
                    
            })
        }
    }
    
    @IBAction func anonymousLogin(_ sender: UIButton) {
        
        if let alertController = Reachability.connectionWarning() {
            
            present(alertController, animated: true, completion: nil)
            
        } else {
            
            let keychain = Keychain(service: "com.george.CosTogether")
            keychain[FirebaseType.uuid.rawValue] = "anonymous"
            
            AppDelegate.shared.switchMainPage()
            
        }
        
    }
}
