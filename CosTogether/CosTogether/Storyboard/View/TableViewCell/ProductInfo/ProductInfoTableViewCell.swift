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
    
    func getProductSetting(name: String?, price: String?, number: String?)
    
}

class ProductInfoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var appendBot: UIButton!
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
    
    @IBAction func appendProductBotTapping(_ sender: UIButton) {
        
        
        guard let productName = productNameTxf.text,
            productName != "" else {
                
                BaseNotificationBanner.warningBanner(subtitle: "請輸入商品名稱")
                return
        }
        
        guard let productPrice = Int(productPriceTxf.text!) else {
            
            BaseNotificationBanner.warningBanner(subtitle: "請輸入正確金額")
            return
        }
        
        guard productPrice > 0 else {
            
            BaseNotificationBanner.warningBanner(subtitle: "金額不得為零")
            return
        }
        
        guard productPrice < 100000 else {
            
            BaseNotificationBanner.warningBanner(subtitle: "金額不得超過十萬")
            return
        }
        
        
        guard productQuantity > 0 else {
            
            BaseNotificationBanner.warningBanner(subtitle: "數量不得為零")
            return
        }
        
        guard productQuantity < 100 else {
            
            BaseNotificationBanner.warningBanner(subtitle: "數量不得超過一百")
            return
        }
        
        
        let product = ProductModel(
            productName: productName,
            productImage: "",
            numberOfItem: productQuantity,
            price: productPrice,
            updateImage: nil
        )

        
    }
    
    
}

extension ProductInfoTableViewCell: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        guard  let delegate = delegate else {
            return
        }
        
        delegate.getProductSetting(
            name: productNameTxf.text ?? "",
            price: productPriceTxf.text ?? "",
            number: numberOfProductTxf.text ?? ""
        )
        
    }
    
}