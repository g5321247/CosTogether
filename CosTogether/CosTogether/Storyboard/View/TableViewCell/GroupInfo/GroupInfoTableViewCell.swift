//
//  GroupInfoTableViewCell.swift
//  CosTogether
//
//  Created by George Liu on 2018/10/24.
//  Copyright © 2018 George Liu. All rights reserved.
//

import UIKit

class GroupInfoTableViewCell: UITableViewCell {

    @IBOutlet weak var locationTxf: UITextField!
    @IBOutlet weak var titleTxf: UITextField!
    @IBOutlet weak var otherInfoTextView: UITextView!
    @IBOutlet weak var createGroupBot: UIButton!
    @IBOutlet weak var cancelBot: UIButton!

    
    @IBAction func cancelBotTapping(_ sender: UIButton) {
        
        
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
 
    private func setup() {
        
         viewSetup()
        
    }
    
    private func viewSetup() {
        
        locationTxf.cornerSetup(
            cornerRadius: 4,
            borderWidth: 1,
            borderColor: #colorLiteral(red: 0.768627451, green: 0.768627451, blue: 0.768627451, alpha: 1),
            maskToBounds: true
        )
        
        titleTxf.cornerSetup(
            cornerRadius: 4,
            borderWidth: 1,
            borderColor: #colorLiteral(red: 0.768627451, green: 0.768627451, blue: 0.768627451, alpha: 1),
            maskToBounds: true
        )
        
        otherInfoTextView.cornerSetup(
            cornerRadius: 4,
            borderWidth: 1,
            borderColor: #colorLiteral(red: 0.768627451, green: 0.768627451, blue: 0.768627451, alpha: 1),
            maskToBounds: true
        )
        
        cancelBot.cornerSetup(cornerRadius: 4)
        createGroupBot.cornerSetup(cornerRadius: 4)
        
    }
    
  
    
    
}
