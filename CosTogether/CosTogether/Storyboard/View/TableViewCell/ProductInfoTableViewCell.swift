//
//  ProductDetailTableViewCell.swift
//  CosTogether
//
//  Created by George Liu on 2018/10/24.
//  Copyright © 2018 George Liu. All rights reserved.
//

import UIKit

class ProductInfoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var appendBot: UIButton!
    @IBOutlet weak var productNameTxf: UITextField!
    @IBOutlet weak var numberOfProductTxf: UITextField!
    @IBOutlet weak var productPriceTxf: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setup()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    private func setup() {
        
        viewSetup()
    }
    
    private func viewSetup() {
        
        appendBot.cornerSetup(cornerRadius: 4)
        productNameTxf.cornerSetup(
            cornerRadius: 4,
            borderWidth: 1,
            borderColor: #colorLiteral(red: 0.768627451, green: 0.768627451, blue: 0.768627451, alpha: 1),
            maskToBounds: true
        )
        
        productPriceTxf.cornerSetup(
            cornerRadius: 4,
            borderWidth: 1,
            borderColor: #colorLiteral(red: 0.768627451, green: 0.768627451, blue: 0.768627451, alpha: 1),
            maskToBounds: true
        )
        
        numberOfProductTxf.cornerSetup(
            cornerRadius: 4,
            borderWidth: 1,
            borderColor: #colorLiteral(red: 0.768627451, green: 0.768627451, blue: 0.768627451, alpha: 1),
            maskToBounds: true
        )

    }
}
