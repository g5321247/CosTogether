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
        amoutQuantity.text = String(product.numberOfItem)
        
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
    
    private func caculation() {
        
        guard numberOfProductTxF.text != "" else {
            
            buyNumberLbl.text = "0"
            totalPriceLbl.text = "0"
            
            return
        }
        
        guard  let totalNumber = Int(buyNumberLbl.text!) else {
            return
        }
        
        guard let price = Int(itemPrice.text!) else {
            return
        }
        
        buyNumberLbl.text = numberOfProductTxF.text

        totalPriceLbl.text = "\(totalNumber * price)"

    }
    
    @IBAction func increaseBotTapping(_ sender: UIButton) {
        
        guard numberOfProductTxF.text! != "" else {
            
            numberOfProductTxF.text! = "0"
            return
        }
        
        guard  let number = Int.parse(from: numberOfProductTxF.text!)  else {
            
            #warning ("通知 controller present")
//            self.present(
//                UIAlertController.errorMessage(errorType:
//                    UserMiscouductError.putStrInPrice),
//                animated: true,
//                completion: nil
//            )
            
            return
        }
        
        guard let quantity = Int.parse(from: amoutQuantity.text!) else {
            return
        }
        
        guard number < quantity else {
            
            numberOfProductTxF.text = "0"
            return
        }
        
        numberOfProductTxF.text = "\(number + 1)"
        caculation()
    }
    
    @IBAction func decreaseBotTapping(_ sender: UIButton) {
        
        if numberOfProductTxF.text! == "" {
            
            numberOfProductTxF.text! = "0"
        }
        
        guard  let number = Int.parse(from: numberOfProductTxF.text!) else {
            return
        }
        
        guard number > 0 else {
            
            return
        }

        numberOfProductTxF.text = "\(number - 1)"
        caculation()
    }
    
}

extension ProductItemTableViewCell: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        guard let number = Int(textField.text!), number > 0,
            let totalQuantity = Int(amoutQuantity.text!), number <= totalQuantity else {
            
            textField.text = ""
            caculation()
            return
        }
        
        caculation()

    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField.text == "" {
            textField.text = "0"
            caculation()
        }
        
        caculation()

    }
}
