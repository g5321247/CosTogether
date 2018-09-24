//
//  UIImageView.swift
//  CosTogether
//
//  Created by George Liu on 2018/9/24.
//  Copyright © 2018 George Liu. All rights reserved.
//

import UIKit

extension UIImageView {
    
    func viewSetUp() {
        
        self.layer.shadowOffset = CGSize(width: 2, height: 2)
        self.layer.shadowRadius = 4.0
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOpacity = 0.6
        
        self.layer.cornerRadius = 10
        
    }

}
