//
//  ProductCollectionViewCell.swift
//  CosTogether
//
//  Created by George Liu on 2018/9/23.
//  Copyright © 2018 George Liu. All rights reserved.
//

import UIKit

class ProductCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var photoImage: UIImageView!
    @IBOutlet weak var authorImage: UIImageView!
    
    @IBOutlet weak var titleLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        photoImage.cornerSetup(cornerRadius: 4)
        
        authorImage.cornerSetup(
            cornerRadius: authorImage.frame.width / 2,
            borderWidth: 4,
            borderColor: UIColor.white.cgColor
        )
        
        setCellShadow()
    }

    func setCellShadow() {
        
        // 要 masksToBounds，不然圓角不會出來
        
        self.contentView.layer.cornerRadius = 2.0
        self.contentView.layer.borderWidth = 1.0
        self.contentView.layer.borderColor = UIColor.clear.cgColor
        self.contentView.layer.masksToBounds = true
        
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowPath = UIBezierPath(
            roundedRect: self.bounds,
            cornerRadius: self.contentView.layer.cornerRadius
        ).cgPath
        
        // 為何 shadowOffset 偏移有差
        
        self.layer.shadowOffset = CGSize(width: 16, height: 12)
        self.layer.shadowRadius = 4.0
        self.layer.shadowOpacity = 0.5
        self.layer.masksToBounds = false
        
    }
    
}
