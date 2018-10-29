//
//  ProductInfoHeader.swift
//  CosTogether
//
//  Created by George Liu on 2018/10/29.
//  Copyright © 2018 George Liu. All rights reserved.
//

import UIKit

class ProductInfoHeader: UIView {
    
    @IBOutlet weak var addBot: UIButton!
    @IBOutlet weak var picIconImage: UIImageView!
    @IBOutlet weak var productNameLbl: UILabel!
    @IBOutlet weak var productNumberLbl: UILabel!
    @IBOutlet weak var productPriceLbl: UILabel!
    @IBOutlet weak var productImageBot: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    
    func updateProductImage(image: UIImage?) {
        
        guard let image = image else {
            
            return
        }
        
        productImageBot.setImage(image, for: .normal)
        picIconImage.isHidden = true
        productImageBot.imageView?.contentMode = .scaleAspectFill
        
        addBot.isHidden = true
        
        productPriceLbl.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        productNumberLbl.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
    }
    
    private func setup() {
        
        productPriceLbl.isHidden = true
        productNumberLbl.isHidden = true
        productNameLbl.isHidden = true
    }
    
}
