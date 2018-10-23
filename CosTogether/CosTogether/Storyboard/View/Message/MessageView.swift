//
//  MessageView.swift
//  CosTogether
//
//  Created by George Liu on 2018/9/25.
//  Copyright © 2018 George Liu. All rights reserved.
//

import UIKit

class MessageView: UIView {
    
    @IBOutlet weak var messgaeTxtView: UITextView!
    @IBOutlet weak var sendMessageBot: UIButton!
    
    weak var delegate: CellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setup()
    }
    
    private func setup() {
        
        setupImageView()
    }
    
    private func setupImageView() {
        
        messgaeTxtView.cornerSetup(
            cornerRadius: 2,
            borderWidth: 1,
            borderColor: #colorLiteral(red: 0.6549019608, green: 0.6745098039, blue: 0.7137254902, alpha: 1),
            maskToBounds: true
        )
        
        messgaeTxtView.text = "跟主揪說點什麼吧..."
        messgaeTxtView.textColor = UIColor.lightGray
        
    }
    
    @IBAction func sendCommentTappng(_ sender: Any) {
        
        guard messgaeTxtView.textColor != UIColor.lightGray,
        let text = messgaeTxtView.text else {
            
            return
        }
        
        delegate?.updateLocalData(data: text)
        
        messgaeTxtView.text = ""
        
    }
    
}
