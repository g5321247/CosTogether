//
//  CellClass.swift
//  CosTogether
//
//  Created by George Liu on 2018/9/27.
//  Copyright © 2018 George Liu. All rights reserved.
//

import Foundation

enum CellClass {
    
    case productPic
    case articleInfo
    case productItems(Int)
    
    func numberOfRow() -> Int {
        
        switch self {
            
        case .productPic:
            
            return 1
        
        case .articleInfo:
            
            return 1
        
        case .productItems(let number):
            
            return number
            
        }
    }
}
