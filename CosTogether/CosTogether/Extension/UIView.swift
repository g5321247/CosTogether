//
//  UIImageView.swift
//  CosTogether
//
//  Created by George Liu on 2018/9/24.
//  Copyright © 2018 George Liu. All rights reserved.
//

import UIKit

extension UIView {
    
    func cornerSetup(cornerRadius: CGFloat) {
        
        self.layer.masksToBounds = true
        self.layer.cornerRadius = cornerRadius
        
    }

    func shadowSetup(
        cgSize: CGSize = CGSize(width: 2, height: 2),
        shadowRadius: CGFloat = 4,
        shadowOpacity: Float = 0.6
        ) {
        
        self.layer.shadowOffset = cgSize
        self.layer.shadowRadius = shadowRadius
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = shadowOpacity
        
    }
    
}
