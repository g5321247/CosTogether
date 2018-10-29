//
//  UserCalculateTableViewCell.swift
//  CosTogether
//
//  Created by George Liu on 2018/10/17.
//  Copyright © 2018 George Liu. All rights reserved.
//

import UIKit

class UserCalculateHeaderTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var userImageBot: UIButton!
    
    var pdoducts: [ProductModel] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func selfBuyerInfoUpdate(userName: String, useImage: String, pdoducts: [ProductModel]) {
        
        self.pdoducts = pdoducts
        
        var amount = 0
        
        for value in pdoducts {
            
            amount += value.price * value.numberOfItem
            
        }
        
        userNameLbl?.text = userName
        
        let url = URL(string: useImage)
        
        userImageBot.sd_setImage(with: url, for: .normal)
        
    }
    
    private func setup() {
        collectionviewSetup()
    }
    
    private func collectionviewSetup() {


      
    }
    
    
}
