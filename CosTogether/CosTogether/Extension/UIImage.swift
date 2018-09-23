//
//  UIImage.swift
//  
//
//  Created by George Liu on 2018/9/23.
//

import UIKit

extension UIImage {
    
    class func getColoredRectImageWith(color: CGColor, andSize size: CGSize) -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        
        let graphicsContext = UIGraphicsGetCurrentContext()
        graphicsContext?.setFillColor(color)
        
        let rectangle = CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height)
        graphicsContext?.fill(rectangle)
        
        let rectangleImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return rectangleImage!
    }
    
}
