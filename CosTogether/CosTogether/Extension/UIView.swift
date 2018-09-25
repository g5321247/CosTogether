//
//  UIImageView.swift
//  CosTogether
//
//  Created by George Liu on 2018/9/24.
//  Copyright © 2018 George Liu. All rights reserved.
//

import UIKit

extension UIView {
    
    func cornerSetup(cornerRadius: CGFloat, borderWidth: CGFloat = 0, borderColor: CGColor? = nil) {
        
        self.layer.masksToBounds = true
        self.layer.cornerRadius = cornerRadius
        
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor
    }

    func shadowSetup(
        cgSize: CGSize = CGSize(width: 18, height: 18),
        shadowRadius: CGFloat = 8,
        shadowOpacity: Float = 0.9
        ) {
        
        self.layer.shadowOffset = cgSize
        self.layer.shadowRadius = shadowRadius
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = shadowOpacity
        
    }
    
}
