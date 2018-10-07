//
//  ProductItemTableViewCell.swift
//  CosTogether
//
//  Created by George Liu on 2018/9/26.
//  Copyright © 2018 George Liu. All rights reserved.
//

import UIKit

class ProductItemTableViewCell: UITableViewCell {

    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productNameLbl: UILabel!
    @IBOutlet weak var itemPrice: UILabel!
    @IBOutlet weak var expiredDate: UILabel!
    @IBOutlet weak var amoutQuantity: UILabel!
    
    @IBOutlet weak var totalPriceLbl: UILabel!
    @IBOutlet weak var buyNumberLbl: UILabel!
    
    @IBOutlet weak var decreaseNumBot: UIButton!
    @IBOutlet weak var increaseNumBot: UIButton!
    
    var productModel: ProductModel?
    
    var handler: ((ProductModel) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func updateView(product: ProductModel) {
        
        #warning ("照片更新")
//        productImage.sd_setImage(with: , completed: )
        productNameLbl.text = product.productName
        itemPrice.text = String(product.price)
        amoutQuantity.text = "總數 \(product.numberOfItem)"
        expiredDate.text = "有效期限 \(product.expiredDate)"
        
        buyNumberLbl.text = "0"
    }
    
    private func setup() {
        
        setButtonView()

        guard  let productModel = productModel else {
            return
        }
        
    }
    
    private func setButtonView() {
        
        decreaseNumBot.cornerSetup(
            cornerRadius: decreaseNumBot.frame.width / 2,
            borderWidth: 2,
            borderColor: #colorLiteral(red: 0.3364960849, green: 0.3365047574, blue: 0.3365000486, alpha: 1)
        )
        
        increaseNumBot.cornerSetup(
            cornerRadius: decreaseNumBot.frame.width / 2,
            borderWidth: 2,
            borderColor: #colorLiteral(red: 0.3364960849, green: 0.3365047574, blue: 0.3365000486, alpha: 1)
        )
        
    }
    
    private func caculation(
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

        totalPriceLbl.text = "$\(price * quantity)"
        
    }
    
    @IBAction func increaseBotTapping(_ sender: UIButton) {
        
        guard let productModel = productModel,
            let number = Int(buyNumberLbl.text!),
            number < (productModel.numberOfItem) else {
                
                return
        }
        
        buyNumberLbl.text = "\(number + 1)"
        
        caculation(
            price: productModel.price,
            quantity: number + 1,
            productName: productModel.productName
        )
        
    }
    
    @IBAction func decreaseBotTapping(_ sender: UIButton) {
        
        guard let productModel = productModel else {
            return
        }
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
        
    }
    
    func updatePurchasing(purchasing: @escaping (ProductModel) -> Void) {
        
        handler = purchasing
    }
    
}
