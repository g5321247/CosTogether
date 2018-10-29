//
//  ImageTableViewCell.swift
//  CosTogether
//
//  Created by George Liu on 2018/10/24.
//  Copyright © 2018 George Liu. All rights reserved.
//

import UIKit

class ImageTableViewCell: UITableViewCell {

    @IBOutlet weak var picIconImage: UIImageView!
    @IBOutlet weak var productNameLbl: UILabel!
    @IBOutlet weak var productNumberLbl: UILabel!
    @IBOutlet weak var productPriceLbl: UILabel!
    @IBOutlet weak var productImageBot: UIButton!
    @IBOutlet weak var addBot: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func updateProduct(product: ProductModel) {
     
        productIsExsit()
        
        productNameLbl.text = product.productName
        productNumberLbl.text = "數量： \(product.numberOfItem)"
        productPriceLbl.text = "單價： \(product.price)"
        
        guard let image = product.updateImage else {
            return
        }
        
        productImageBot.setImage(image, for: .normal)
        
    }
    
    private func productIsExsit() {
        
        addBot.isHidden = true
        picIconImage.isHidden = true
        
        productNumberLbl.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        productPriceLbl.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        productImageBot.imageView?.contentMode = .scaleAspectFill

    }
    
    func updateName(name: String) {
        
        productNameLbl.text = name

    }
    
    func updateNumber(number: Int) {
        
        productNumberLbl.text = "數量： \(number)"
        
    }
    
    func updatePrice(price: Int) {
        
        productPriceLbl.text = "單價： \(price)"
        
    }
    
    func updateProductImage(image: UIImage?) {
        
        guard let image = image else {
            
            return
        }
        
        productImageBot.setImage(image, for: .normal)
        
        productIsExsit()
    }

}
