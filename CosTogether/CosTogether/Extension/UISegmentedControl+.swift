//
//  UISegmentedControl.swift
//  CosTogether
//
//  Created by George Liu on 2018/9/23.
//  Copyright © 2018 George Liu. All rights reserved.
//

import UIKit

extension UISegmentedControl {
    
    func removeBorder() {

        let backgroundImage = UIImage.getColoredRectImageWith(color: UIColor.white.cgColor, andSize: self.bounds.size)
        
        self.setBackgroundImage(backgroundImage, for: .normal, barMetrics: .default)
        self.setBackgroundImage(backgroundImage, for: .selected, barMetrics: .default)
        self.setBackgroundImage(backgroundImage, for: .highlighted, barMetrics: .default)
        
        let deviderImage = UIImage.getColoredRectImageWith(
            color: UIColor.white.cgColor,
            andSize: CGSize(width: 1.0, height: self.bounds.size.height)
        )
        
        self.setDividerImage(
            deviderImage,
            forLeftSegmentState: .selected,
            rightSegmentState: .normal,
            barMetrics: .default
        )
        
        let font = Fonts.notoSansBold.uiFont(fontSize: 16) ?? UIFont.systemFont(ofSize: 16)
        
        self.setTitleTextAttributes(
            [
                NSAttributedString.Key.foregroundColor: UIColor.gray,
                NSAttributedString.Key.font: font
            ],
            for: .normal
        )
        
        self.setTitleTextAttributes(
            [
                NSAttributedString.Key.foregroundColor:
                #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            ],
            for: .selected
        )
        
    }
    
    func addUnderlineForSelectedSegment() {
        
        removeBorder()
        
        let underlineWidth: CGFloat = (self.bounds.size.width / CGFloat(self.numberOfSegments))
        let underlineHeight: CGFloat = 2.0
        let underlineXPosition = CGFloat(selectedSegmentIndex * Int(underlineWidth))
        let underLineYPosition = self.bounds.size.height - 1.0
        let underlineFrame = CGRect(
            x: underlineXPosition,
            y: underLineYPosition,
            width: underlineWidth,
            height: underlineHeight
        )
        
        let underline = UIView(frame: underlineFrame)
        
        underline.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        underline.tag = 1
        
        self.addSubview(underline)
    }
    
    func changeUnderlinePosition() {
        
        guard let underline = self.viewWithTag(1) else { return }
        
        let underlineFinalXPosition =
            (self.bounds.width / CGFloat(self.numberOfSegments)) *
            CGFloat(selectedSegmentIndex)
        
        UIView.animate(withDuration: 0.1, animations: {
            underline.frame.origin.x = underlineFinalXPosition
        })
        
    }
}
