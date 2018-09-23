//
//  UIButton.swift
//  CosTogether
//
//  Created by George Liu on 2018/9/23.
//  Copyright © 2018 George Liu. All rights reserved.
//

import UIKit

extension UIButton {
    
    func setButton(color: UIColor) {
        
        self.layer.cornerRadius = 5
        
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = 1
        
        self.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.layer.shadowRadius = 1.0
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOpacity = 0.3
    }
    
}
