//
//  UISearchBar.swift
//  CosTogether
//
//  Created by George Liu on 2018/9/23.
//  Copyright © 2018 George Liu. All rights reserved.
//

import UIKit

extension UISearchBar {

    func removeBackgroundColor() {
        
        self.backgroundImage = UIImage()
        
    }
    
    func setSearchBar() {
        
        removeBackgroundColor()
        
        for subView in self.subviews {
            
            for subsubView in subView.subviews {
                
                if let textField = subsubView as? UITextField {
                    
                    textField.layer.borderWidth = 1
                    textField.layer.borderColor = UIColor.gray.cgColor
                    textField.layer.cornerRadius = 10
                }
                
            }
            
        }

    }
    
}
