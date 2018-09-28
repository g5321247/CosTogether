//
//  MainNavigationViewController.swift
//  CosTogether
//
//  Created by George Liu on 2018/9/25.
//  Copyright © 2018 George Liu. All rights reserved.
//

import UIKit

class MainNavigationViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationBar.barTintColor = UIColor.white
        
        setFont()
    }
    
    func setFont() {
        
        let font = Fonts.baskervilleBold.uiFont(fontSize: 24) ?? UIFont.systemFont(ofSize: 24)
        
        self.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: font]
    }
    
}
