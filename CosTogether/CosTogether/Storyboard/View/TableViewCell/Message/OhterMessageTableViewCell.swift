//
//  OhterMessageTableViewCell.swift
//  CosTogether
//
//  Created by George Liu on 2018/9/30.
//  Copyright © 2018 George Liu. All rights reserved.
//

import UIKit

class OhterMessageTableViewCell: UITableViewCell {

    @IBOutlet weak var messageLbl: UILabel!
    @IBOutlet weak var userPhotoBot: UIButton!
    @IBOutlet weak var snedDateLbl: UILabel!
     @IBOutlet weak var userNameLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
