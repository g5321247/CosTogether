//
//  Fonts.swift
//  
//
//  Created by George Liu on 2018/9/23.
//

import UIKit

enum Fonts: String {
    
    case notoSansBold = "NotoNastaliqUrdu"
    case notoSansRegular = "NotoSansChakma-Regular"
    case baskerville = "Baskerville"
    case baskervilleBold = "Baskerville-Bold"
    
    func uiFont(fontSize: CGFloat) -> UIFont? {
        
        return UIFont(name: self.rawValue, size: fontSize)
    }
    
}
