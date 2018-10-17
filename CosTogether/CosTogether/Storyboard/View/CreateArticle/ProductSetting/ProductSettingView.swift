//
//  ProductSettingView.swift
//  CosTogether
//
//  Created by George Liu on 2018/10/7.
//  Copyright © 2018 George Liu. All rights reserved.
//

import UIKit
import NotificationBannerSwift

protocol ProductSettingDelegate: AnyObject {
    
    func getProductSetting(product: ProductModel)
    
}

class ProductSettingView: UIView {
    
    @IBOutlet weak var decreaseNumBot: UIButton!
    @IBOutlet weak var increaseNumBot: UIButton!
    @IBOutlet weak var productQuantityLbl: UILabel!
    @IBOutlet weak var productNameTxf: UITextField!
    @IBOutlet weak var productPriceTxf: UITextField!
    
    var productQuantity: Int = 0
    
    weak var delegate: ProductSettingDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setup()
    }
    
    private func setup() {
        viewSetup()
        setButton()
    }
    
    private func viewSetup() {
        
        self.cornerSetup(
            cornerRadius: 4,
            borderWidth: 1,
            borderColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) ,
            maskToBounds: true
        )
    }
    
    private func setButton() {
        
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
        
        decreaseNumBot.addTarget(
            self,
            action: #selector (quantityBotTapping(_:)),
            for: .touchUpInside
        )
        increaseNumBot.addTarget(
            self,
            action: #selector ((quantityBotTapping(_:))),
            for: .touchUpInside
        )

    }
    
    func updateProductDetail(product: ProductModel) {
        
        productQuantity = product.numberOfItem
        productQuantityLbl.text = "\(productQuantity)"
        productNameTxf.text = product.productName
        productPriceTxf.text = "\(product.price)"
        
    }
    
    @objc func quantityBotTapping(_ sender: UIButton) {
        
        if sender == increaseNumBot {
            
            guard productQuantity < 99 else {
                
                return
            }
            
            productQuantity += 1
            
            productQuantityLbl.text = "\(productQuantity)"
            
        } else if sender == decreaseNumBot {
            
            guard productQuantity > 0 else {
                
                return
            }
            
            productQuantity -= 1
            
            productQuantityLbl.text = "\(productQuantity)"
            
        }
        
    }
    
    func updateProductInfo() {
        
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

        guard  let delegate = delegate else {
            return
        }
        
        delegate.getProductSetting(product: product)
        
    }
    
}
