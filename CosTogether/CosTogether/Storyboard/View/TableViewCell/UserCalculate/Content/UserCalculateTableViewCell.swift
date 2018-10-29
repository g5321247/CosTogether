//
//  UserCalculateTableViewCell.swift
//  CosTogether
//
//  Created by George Liu on 2018/10/24.
//  Copyright © 2018 George Liu. All rights reserved.
//

import UIKit

class UserCalculateTableViewCell: UITableViewCell {
    
    @IBOutlet weak var productDetailLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func selfBuyerInfoUpdate(pdoduct: ProductModel) {
        
        productDetailLbl.text = "\(pdoduct.productName) x \(pdoduct.numberOfItem)"
        
    }
    
}
