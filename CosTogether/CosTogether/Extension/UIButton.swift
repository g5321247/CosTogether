//
//  UIButton.swift
//  CosTogether
//
//  Created by George Liu on 2018/9/23.
//  Copyright © 2018 George Liu. All rights reserved.
//

import UIKit

extension UIButton {
    
    func setCornerRadius(color: UIColor) {
        
        self.layer.cornerRadius = 5
        
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = 1
        
    }
    
}