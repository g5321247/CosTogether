//
//  PreviousCommentTableViewCell.swift
//  CosTogether
//
//  Created by George Liu on 2018/9/29.
//  Copyright © 2018 George Liu. All rights reserved.
//

import UIKit

class PreviousCommentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var sendDataLbl: UILabel!
    @IBOutlet weak var commenterNameLbl: UILabel!
    @IBOutlet weak var commentLbl: UILabel!
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var commenterBot: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    
    private func setup() {
        
        commenterBotSetup()
    }
    
    private func commenterBotSetup() {
        
        commenterBot.cornerSetup(
            cornerRadius: CGFloat(commenterBot.frame.width / 2),
            borderWidth: 0.5,
            borderColor: UIColor.black.cgColor,
            maskToBounds: true
        )
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setup()
    }
    
}
