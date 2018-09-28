//
//  OrderTableViewCell.swift
//  CosTogether
//
//  Created by George Liu on 2018/9/28.
//  Copyright © 2018 George Liu. All rights reserved.
//

import UIKit

class OrderTableViewCell: UITableViewCell {

    @IBOutlet weak var orderBot: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setup()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    private func setup() {
        setButton()
    }
    
    private func setButton() {
        
        orderBot.cornerSetup(cornerRadius: 3)
        
    }
    
}
