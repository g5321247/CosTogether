//
//  NewProductView.swift
//  CosTogether
//
//  Created by George Liu on 2018/10/7.
//  Copyright © 2018 George Liu. All rights reserved.
//

import UIKit

class NewProductView: UIView {

    @IBOutlet weak var productNameLbl: UILabel!
    @IBOutlet weak var productPriceLbl: UILabel!
    @IBOutlet weak var productQuntityLbl: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var priceImage: UIImageView!
    @IBOutlet weak var quantityImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    private func setup() {
        viewSetup()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        setup()

    }
    
    private func viewSetup() {
        
        productImage.cornerSetup(cornerRadius: 4)
        
        setViewToBeTemplate()
    }
    
    private func setViewToBeTemplate() {
        
        priceImage.image = priceImage.image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        
        quantityImage.image = quantityImage.image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        
    }
}
