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
    
    func addDashdeBorderLayer(color: UIColor, lineWidth width: CGFloat) {
        
        let shapeLayer = CAShapeLayer()
        let size = self.frame.size
        
        let shapeRect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        
        shapeLayer.bounds = shapeRect
        shapeLayer.position = CGPoint(x: size.width * 0.5, y: size.height * 0.5)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.lineWidth = width
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
    
        shapeLayer.lineDashPattern = [4, 4]
        let path = UIBezierPath(roundedRect: shapeRect, cornerRadius: 0)
        shapeLayer.path = path.cgPath
        self.layer.addSublayer(shapeLayer)
        
    }

}
