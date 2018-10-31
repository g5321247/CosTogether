//
//  OpenGroupType.swift
//  CosTogether
//
//  Created by George Liu on 2018/10/5.
//  Copyright © 2018 George Liu. All rights reserved.
//

import Foundation

enum OpenGroupType: String, Codable{
    
    case shareBuy = "分購"
    case helpBuy = "代購"
 
    enum CodingKeys: String, CodingKey {
        
        case shareBuy = "分購"
        case helpBuy = "代購"

    }
    
}

enum MyGroup: String, Codable {
    
    case join
    case own
    
}
