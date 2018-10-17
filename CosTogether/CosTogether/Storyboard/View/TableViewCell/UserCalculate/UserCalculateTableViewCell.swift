//
//  UserCalculateTableViewCell.swift
//  CosTogether
//
//  Created by George Liu on 2018/10/17.
//  Copyright © 2018 George Liu. All rights reserved.
//

import UIKit

class UserCalculateTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var userImageBot: UIButton!
    @IBOutlet weak var totalAmountLbl: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func selfBuyerInfoUpdate(userName: String, useImage: String, pdoducts: [ProductModel]) {
        
        var amount = 0
        
        for value in pdoducts {
            
            amount += value.price * value.numberOfItem
            
        }
        
        userNameLbl?.text = userName
        
        totalAmountLbl.text = "\(amount)"
        
        
        let url = URL(string: useImage)
        
        userImageBot.sd_setImage(with: url, for: .normal)
    }

}
