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
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var postDateLbL: UILabel!
    
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
        
        photoImage.cornerSetup(cornerRadius: 4)
        
        authorImage.cornerSetup(
            cornerRadius: authorImage.frame.height / 2,
            borderWidth: 4,
            borderColor: UIColor.white.cgColor
        )
        
        authorImage.clipsToBounds = true
        
        setCellShadow()

    }
    
    private func setCellShadow() {
        
        // 要 masksToBounds，不然圓角不會出來
        
        self.contentView.layer.cornerRadius = 2.0
        self.contentView.layer.borderWidth = 1.0
        self.contentView.layer.borderColor = UIColor.clear.cgColor
        self.contentView.layer.masksToBounds = true
        
        self.layer.shadowOffset = CGSize(width: 4, height: 4)
        self.layer.shadowRadius = 4.0
        self.layer.shadowOpacity = 0.5
        self.layer.masksToBounds = false
        
    }
    
    func updateGroupInfo(
        productUrl: String,
        authorUrl: String,
        title: String,
        location: String,
        postDate: String
        ) {
        
        titleLbl.text = title
        locationLbl.text = location
        postDateLbL.text = postDate
        
        guard productUrl != "" else {

            photoImage.image = #imageLiteral(resourceName: "picture")
            
            let authorUrl = URL(string: authorUrl)
            authorImage.sd_setImage(with: authorUrl)
            
            return
        }
        
        let productUrl = URL(string: productUrl)
        photoImage.sd_setImage(with: productUrl)

        guard authorUrl != "" else {
            
            authorImage.image = #imageLiteral(resourceName: "profile_sticker_placeholder02")
            
            return
        }
        
        let authorUrl = URL(string: authorUrl)
        authorImage.sd_setImage(with: authorUrl)
        
    }
        
}
