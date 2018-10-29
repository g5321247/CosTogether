//
//  UserCalculateFooter.swift
//  CosTogether
//
//  Created by George Liu on 2018/10/25.
//  Copyright © 2018 George Liu. All rights reserved.
//

import UIKit

class UserCalculateFooter: UIView {

    @IBOutlet weak var amountLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func selfBuyerInfoUpdate(products: [ProductModel]) {
        
        var amount = 0
        
        for product in products {
            
            amount += (product.price * product.numberOfItem)
            
        }
        
        amountLbl.text = "\(amount) 元"
        
    }
    
}
