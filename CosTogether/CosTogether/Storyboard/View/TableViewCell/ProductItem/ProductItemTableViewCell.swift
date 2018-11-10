//
//  ProductItemTableViewCell.swift
//  CosTogether
//
//  Created by George Liu on 2018/9/26.
//  Copyright © 2018 George Liu. All rights reserved.
//

import UIKit
import NotificationBannerSwift

class ProductItemTableViewCell: UITableViewCell {

    @IBOutlet fileprivate weak var productImage: UIImageView!
    @IBOutlet fileprivate weak var productNameLbl: UILabel!
    @IBOutlet fileprivate weak var itemPrice: UILabel!
    @IBOutlet fileprivate weak var amoutQuantity: UILabel!
    
    @IBOutlet fileprivate weak var buyNumberLbl: UILabel!
    
    @IBOutlet fileprivate weak var decreaseNumBot: UIButton!
    @IBOutlet fileprivate weak var increaseNumBot: UIButton!
    
    var productModel: ProductModel?
    
    var handler: ((ProductModel) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        setup()
    }
    
    private func setup() {
        
        productImage.cornerSetup(cornerRadius: 4)
        
    }
    
    func updateView(product: ProductModel) {
        
        guard let productUrl = product.productImage,
            productUrl != "" else {
                
                productImage.image = #imageLiteral(resourceName: "picture")
                
                return
        }
        
        let url = URL(string: productUrl)
        
        productImage.sd_setImage(with: url)
        productNameLbl.text = product.productName
        itemPrice.text = "單價 $" + String(product.price)
        amoutQuantity.text = "總數 \(product.numberOfItem)"
        
        buyNumberLbl.text = "0"
    }
    
    fileprivate func caculation(
        price: Int,
        quantity: Int,
        productName: String
        ) {
        
        buyNumberLbl.text = String(quantity)
        
            handler?(
                ProductModel.purchasingProduct(
                name: productName,
                number: quantity,
                totalCost: price
                )
        )
        
    }
    
    @IBAction func numberOfBotTapping(_ sender: UIButton) {
        
        guard let productModel = productModel else {
            return
        }
        
        switch sender {
            
        case increaseNumBot:
            
            guard let number = Int(buyNumberLbl.text!),
            number < (productModel.numberOfItem) else {
                
                BaseNotificationBanner.warningBanner(subtitle: "數量已達上限")
                
                return
            }
            
            buyNumberLbl.text = "\(number + 1)"
            
            caculation(
                price: productModel.price,
                quantity: number + 1,
                productName: productModel.productName
            )
        
        case decreaseNumBot:
            
            guard let number = Int(buyNumberLbl.text!),
                number > 0 else {
                    
                    caculation(
                        price: 0,
                        quantity: 0,
                        productName: ""
                    )
                    
                    return
            }
            
            buyNumberLbl.text = "\(number - 1)"
            caculation(
                price: productModel.price,
                quantity: number - 1,
                productName: productModel.productName
            )

        default:
            break
        }
        
        
    }
    
    func updatePurchasing(purchasing: @escaping (ProductModel) -> Void) {
        
        handler = purchasing
    }
    
}
