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
    @IBOutlet weak var numberOfProductTxF: UITextField!
    
    var productModel: ProductModel?
    var purchasingProduct: ProductModel?
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
    }
    
    private func setup() {
        
        setButtonView()
        numberOfProductTxF.delegate = self
        
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
        
        buyNumberLbl.text = String(quantity)
        
        purchasingProduct = ProductModel.purchasingProduct(
            name: productName,
            number: quantity,
            totalCost: (price * quantity)
            )
        
        totalPriceLbl.text = "\(price * quantity)"
        
        handler?(purchasingProduct!)
    }
    
    @IBAction func increaseBotTapping(_ sender: UIButton) {
        
        guard let productModel = productModel,
            let number = Int(numberOfProductTxF.text!),
            number < (productModel.numberOfItem) else {
                
                numberOfProductTxF.text = "0"
                caculation(price: 0, quantity: 0, productName: "")

                return
        }
        
        numberOfProductTxF.text = "\(number + 1)"
        
        caculation(
            price: productModel.price,
            quantity: number + 1,
            productName: productModel.productName
        )
        
    }
    
    @IBAction func decreaseBotTapping(_ sender: UIButton) {
        
        guard let productModel = productModel,
            let number = Int(numberOfProductTxF.text!),
            number > 0 else {
            
            caculation(price: 0, quantity: 0, productName: "")

            return
        }
        
        numberOfProductTxF.text = "\(number - 1)"
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

extension ProductItemTableViewCell: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        guard let number = Int(textField.text!), number > 0,
            let productModel = productModel,
            number <= (productModel.numberOfItem) else {
            
            textField.text = ""
            caculation(price: 0, quantity: 0, productName: "")

            return
        }
        
        caculation(
            price: productModel.price,
            quantity: number,
            productName: productModel.productName
        )

    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        guard let productModel = productModel,
            let number = Int(textField.text!),
            number > 0 && number <= productModel.numberOfItem,
            textField.text != "" else {
            
            textField.text = "0"
            caculation(price: 0, quantity: 0, productName: "")

            return
        }
        
        caculation(
            price: productModel.price,
            quantity: number,
            productName: productModel.productName
        )

    }
    
}
