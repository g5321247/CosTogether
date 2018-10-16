//
//  CosNavigationControllerViewController.swift
//  CosTogether
//
//  Created by George Liu on 2018/10/16.
//  Copyright © 2018 George Liu. All rights reserved.
//

import UIKit

class CosNavigationControllerViewController: UINavigationController {

    static var isLightStatusBar: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        
        if CosNavigationControllerViewController.isLightStatusBar {
            
            return .lightContent
            
        } else {
            
            return .default
            
        }
        
    }
    
}
