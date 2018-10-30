//
//  ProductDetailTableViewCell.swift
//  CosTogether
//
//  Created by George Liu on 2018/10/24.
//  Copyright © 2018 George Liu. All rights reserved.
//

import UIKit
import NotificationBannerSwift

protocol ProductSettingDelegate: AnyObject {
    
    func getProductName(name: String?)
    func getProductPrice(price: Int?)
    func getProductNumber(number: Int?)
    
}

class ProductInfoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var productNameTxf: UITextField!
    @IBOutlet weak var numberOfProductTxf: UITextField!
    @IBOutlet weak var productPriceTxf: UITextField!
    
    weak var delegate: ProductSettingDelegate?
    var productQuantity: Int = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setup()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    private func setup() {
        
        viewSetup()
        textfieldDelegateSet()
    }
    
    private func textfieldDelegateSet() {
        
        productNameTxf.delegate = self
        numberOfProductTxf.delegate = self
        productPriceTxf.delegate = self
    
    }
    
    private func viewSetup() {
        
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
    
    func updateProduct(product: ProductModel) {
        
        productNameTxf.text = product.productName
        numberOfProductTxf.text = "\(product.numberOfItem)"
        productPriceTxf.text = "\(product.price)"
        
    }

}

extension ProductInfoTableViewCell: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard  let delegate = delegate,
            let text = textField.text,
            let textRange = Range(range, in: text) else {
            return true
        }
        
        let count = text.count + string.count - range.length
        
        switch textField {
            
        case productNameTxf:
            
            let updatedText = text.replacingCharacters(in: textRange, with: string)
            
            delegate.getProductName(name: updatedText)
            
            guard count <= 6 else {
                
                BaseNotificationBanner.warningBanner(subtitle: "商品名稱不得超過 6 字")
                
                return count <= 6
                
            }
            
            return count <= 6
            
        case numberOfProductTxf:
            
            let updatedText = text.replacingCharacters(in: textRange, with: string)
            
            guard let number = Int(updatedText) else {
                
                BaseNotificationBanner.warningBanner(subtitle: "請輸入正確數量")

                return count < 3
            }
            
            guard count < 3 else {
                
                BaseNotificationBanner.warningBanner(subtitle: "數量不得大於一百")
                
                return count < 3
                
            }

            
            delegate.getProductNumber(number: number)

            return count < 3
 
        case productPriceTxf:
            
            let updatedText = text.replacingCharacters(in: textRange, with: string)
            
            guard let price = Int(updatedText) else {
                
                BaseNotificationBanner.warningBanner(subtitle: "請輸入正確金額")

                return count < 6
            }
            
            guard count < 6 else {
                
                BaseNotificationBanner.warningBanner(subtitle: "金額不得大於十萬")
                
                return count < 6
                
            }
            
            delegate.getProductPrice(price: price)
            
            return count < 6

        default:
            break
        }
        
        return true
    }
    
}
