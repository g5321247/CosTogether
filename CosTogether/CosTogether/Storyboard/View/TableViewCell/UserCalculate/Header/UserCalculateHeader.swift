//
//  UserCalculateHeader.swift
//  CosTogether
//
//  Created by George Liu on 2018/10/24.
//  Copyright © 2018 George Liu. All rights reserved.
//

import UIKit

class UserCalculateHeader: UIView {
    
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var userImageBot: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func selfBuyerInfoUpdate(userName: String, useImage: String) {
        
        userNameLbl?.text = userName
        
        let url = URL(string: useImage)
        
        userImageBot.sd_setImage(with: url, for: .normal)
        
    }
}
