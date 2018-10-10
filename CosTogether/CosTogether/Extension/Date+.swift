//
//  Date+.swift
//  CosTogether
//
//  Created by George Liu on 2018/10/10.
//  Copyright © 2018 George Liu. All rights reserved.
//

import Foundation

extension Date {
    
    static func getCurrentDate() -> String {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "YYYY/MM/dd"
        dateFormatter.locale = Locale.current
        
        return dateFormatter.string(from: Date())
    }
    
}
