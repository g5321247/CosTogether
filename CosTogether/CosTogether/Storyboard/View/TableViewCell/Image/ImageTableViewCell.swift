//
//  ImageTableViewCell.swift
//  CosTogether
//
//  Created by George Liu on 2018/10/24.
//  Copyright © 2018 George Liu. All rights reserved.
//

import UIKit

class ImageTableViewCell: UITableViewCell {

    @IBOutlet weak var addImage: UIImageView!
    @IBOutlet weak var picIconImage: UIImageView!
    @IBOutlet weak var productNameLbl: UILabel!
    @IBOutlet weak var productNumberLbl: UILabel!
    @IBOutlet weak var productPriceLbl: UILabel!
    @IBOutlet weak var productImageBot: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func updateCell(type: CreateType,name: String, number: Int, price: Int, image: UIImage) {
     
        productNameLbl.text = name
        productPriceLbl.text = "\(number)"
        productNumberLbl.text = "\(price)"
        
        
        switch type {
        case .openGroup:
             productImageBot.addTarget(self, action: #selector (choseProductImage(_:)), for: .touchUpInside)
        default:
            break
        }
    }
    
    func updateProductImage(image: UIImage) {
        
        productImageBot.setImage(image, for: .normal)
        picIconImage.isHidden = true
        productImageBot.imageView?.contentMode = .scaleAspectFill
        
        productPriceLbl.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        productNumberLbl.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        let addImageWithTem = #imageLiteral(resourceName: "plus").withRenderingMode(.alwaysTemplate)
        
        addImage.image = addImageWithTem
        addImage.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
    
    @objc func choseProductImage(_ sender: UIButton) {
        
        print("yo")
    }
    

}
