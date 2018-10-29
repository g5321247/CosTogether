//
//  ButtonTableViewCell.swift
//  CosTogether
//
//  Created by George Liu on 2018/10/29.
//  Copyright © 2018 George Liu. All rights reserved.
//

import UIKit

class ButtonTableViewCell: UITableViewCell {

    @IBOutlet weak var appendBot: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
 
    override func layoutSubviews() {
        super.layoutSubviews()
        
        viewSetup()
        
    }
    
    private func viewSetup() {
    
        appendBot.cornerSetup(cornerRadius: 4)
        
    }
    
}
