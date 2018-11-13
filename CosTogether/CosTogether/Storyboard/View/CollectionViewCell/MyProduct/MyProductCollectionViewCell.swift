//
//  MyProductCollectionViewCell.swift
//  CosTogether
//
//  Created by George Liu on 2018/10/17.
//  Copyright © 2018 George Liu. All rights reserved.
//

import UIKit

class MyProductCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var postDateLbl: UILabel!
    @IBOutlet weak var photoImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setup()
    }
    
    private func setup() {
        
        viewSetup()
        
    }
    
    private func viewSetup() {

        setCellShadow()
        
    }
    
    private func setCellShadow() {
        
        // 要 masksToBounds，不然圓角不會出來
        
        self.contentView.layer.cornerRadius = 2.0
        self.contentView.layer.borderWidth = 1.0
        self.contentView.layer.borderColor = UIColor.clear.cgColor
        self.contentView.layer.masksToBounds = true
        
        self.layer.shadowOffset = CGSize(width: 2, height: 2)
        self.layer.shadowRadius = 2.0
        self.layer.shadowOpacity = 0.5
        self.layer.masksToBounds = false
        
    }

    func updateMyProductInfo(numberOfItem: Int, productName: String, price: Int, productImage: String) {
        
        locationLbl.text = "數量：\(numberOfItem)"
        postDateLbl.text = "$\(price)"
        
        let productUrl = URL(string: productImage)
        photoImage.sd_setImage(with: productUrl)
    }

}
