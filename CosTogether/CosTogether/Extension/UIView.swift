//
//  UIImageView.swift
//  CosTogether
//
//  Created by George Liu on 2018/9/24.
//  Copyright © 2018 George Liu. All rights reserved.
//

import UIKit

extension UIView {
    
    func cornerSetup(
        cornerRadius: CGFloat,
        borderWidth: CGFloat = 0,
        borderColor: CGColor? = nil,
        maskToBounds: Bool = true) {
        
        self.layer.masksToBounds = maskToBounds
        self.layer.cornerRadius = cornerRadius
        
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor
    }

    func shadowSetup(
        cgSize: CGSize = CGSize(width: 1, height: 1),
        shadowRadius: CGFloat = 4,
        shadowOpacity: Float = 0.2
        ) {
        
        self.layer.shadowOffset = cgSize
        self.layer.shadowRadius = shadowRadius
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = shadowOpacity
        
    }
    
}
