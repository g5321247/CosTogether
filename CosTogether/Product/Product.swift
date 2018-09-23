//
//  Product.swift
//  CosTogether
//
//  Created by George Liu on 2018/9/23.
//  Copyright © 2018 George Liu. All rights reserved.
//

enum ProductType: String {
    
    case food
    
    case clothing
    
    case housing
    
    case transportation
    
}

enum Location: String {
    
    case taipei
    
    case newTaipei
    
}

struct Product {
    
    let price: Int
    
    let productPicURL: String
    
    let number: Int
    
    let name: String
    
    let productTag: String
    
    let location: String
    
    let tagLocation: String
    
}
