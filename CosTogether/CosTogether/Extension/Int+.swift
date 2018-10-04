//
//  Int.swift
//  CosTogether
//
//  Created by George Liu on 2018/10/2.
//  Copyright © 2018 George Liu. All rights reserved.
//

import Foundation

extension Int {
    
    static func parse(from string: String) -> Int? {
        
        return Int(string.components(
            separatedBy: CharacterSet.decimalDigits.inverted).joined()
        )
        
    }
}
