//
//  LogInViewController.swift
//  CosTogether
//
//  Created by George Liu on 2018/9/19.
//  Copyright © 2018 George Liu. All rights reserved.
//

import UIKit
import KeychainAccess

class LogInViewController: UIViewController {

    @IBOutlet weak var facebookLoginBot: UIButton!
    @IBOutlet weak var anonymousLogInBot: UIButton!
    
    private let fbManager = FacebookManager()
    private let firebaseManager = FirebaseManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setImage()
    }
    
    func setImage() {
        
        facebookLoginBot.layer.cornerRadius = 10
        
        anonymousLogInBot.layer.cornerRadius = 10
        
    }
    
    @IBAction func logInFB(_ sender: UIButton) {
        
        fbManager.facebookLogIn(
            fromController: self,
            sucess: { [weak self ] (token) in
                
                self?.signInFirebase(token: token)
                
        },
            failure: { [weak self ] (error) in
                
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
    
    private func signInFirebase(token: String) {
        
        firebaseManager.logInFirebase(
            token: token,
            sucess: {
            
            DispatchQueue.main.async {
                AppDelegate.shared.switchMainPage()
            }
        
        },
            faliure: { [weak self ] (error) in
            
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
    
    @IBAction func anonymousLogin(_ sender: UIButton) {
        
        let keychain = Keychain(service: "com.george.CosTogether")
        keychain[FirebaseType.uuid.rawValue] = "anonymous"
        
        AppDelegate.shared.switchMainPage()

    }
}
