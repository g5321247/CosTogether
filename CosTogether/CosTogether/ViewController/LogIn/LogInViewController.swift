//
//  LogInViewController.swift
//  CosTogether
//
//  Created by George Liu on 2018/9/19.
//  Copyright © 2018 George Liu. All rights reserved.
//

import UIKit

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
        facebookLoginBot.layer.borderWidth = 1
        facebookLoginBot.layer.borderColor = UIColor.lightGray.cgColor
        
        anonymousLogInBot.layer.cornerRadius = 10
        anonymousLogInBot.layer.borderWidth = 1
        anonymousLogInBot.layer.borderColor = UIColor.lightGray.cgColor
        
        
        
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
            sucess: { (userInfo) in
            
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
    
}
