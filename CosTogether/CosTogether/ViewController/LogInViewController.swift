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
    
    @IBOutlet weak var titleLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setImage()
    }
    
    func setImage() {
        
        facebookLoginBot.layer.cornerRadius = facebookLoginBot.bounds.height / 2
        facebookLoginBot.layer.borderWidth = 1
        facebookLoginBot.layer.borderColor = UIColor.lightGray.cgColor
        
        anonymousLogInBot.layer.cornerRadius = anonymousLogInBot.bounds.height / 2
        anonymousLogInBot.layer.borderWidth = 1
        anonymousLogInBot.layer.borderColor = UIColor.lightGray.cgColor
        
        let layer = CAGradientLayer()
        
        layer.colors = [
            #colorLiteral(red: 0.2470588235, green: 0.4470588235, blue: 0.6862745098, alpha: 1).cgColor,
            #colorLiteral(red: 0.9764705882, green: 0.968627451, blue: 0.968627451, alpha: 1).cgColor
        ]
        
        layer.startPoint = CGPoint(x: 0.0, y: 0.95)

        layer.endPoint = CGPoint(x: 1.0, y: 0.05)
        
        layer.frame = CGRect(
            x: 0,
            y: 0,
            width: view.bounds.width,
            height: view.bounds.height
        )
        
        view.layer.insertSublayer(layer, below: titleLbl.layer)
        
    }
    
}
