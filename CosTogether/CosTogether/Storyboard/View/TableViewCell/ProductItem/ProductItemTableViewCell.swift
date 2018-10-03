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
    var totalCost: Int = 0
    var totalQuantity: Int = 0
    
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
    }
    
    private func setup() {
        
        setButtonView()
        
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
    
    private func caculation(price: Int, quantity: Int, productName: String) {
        
        totalCost += (price * quantity)
        totalQuantity += quantity
        
        buyNumberLbl.text = String(totalQuantity)

            handler?(
                ProductModel.purchasingProduct(
                name: productName,
                number: quantity,
                totalCost: (price * quantity)
                )
        )

        totalPriceLbl.text = "\(totalCost)"
        
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
            quantity: 1,
            productName: productModel.productName
        )
        
    }
    
    @IBAction func decreaseBotTapping(_ sender: UIButton) {
        
        guard let productModel = productModel,
            let number = Int(buyNumberLbl.text!),
            number > 0 else {
            
            caculation(price: 0, quantity: 0, productName: "")

            return
        }
        
        buyNumberLbl.text = "\(number - 1)"
        caculation(
            price: productModel.price,
            quantity: -1,
            productName: productModel.productName
        )
        
    }
    
    func updatePurchasing(purchasing: @escaping (ProductModel) -> Void) {
        
        handler = purchasing
    }
    
}
