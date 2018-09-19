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
    
}
