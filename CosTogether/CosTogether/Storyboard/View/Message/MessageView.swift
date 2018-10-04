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
    @IBOutlet weak var textHeightConstraint: NSLayoutConstraint!
    
    weak var delegate: CellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setup()
    }
    
    private func setup() {
        
        setupImageView()
    }
    
    private func setupImageView() {
        
        messgaeTxtView.cornerSetup(cornerRadius: 4)
        messgaeTxtView.text = "跟主揪說點什麼吧..."
        messgaeTxtView.textColor = UIColor.lightGray
        
    }
    
    @IBAction func sendCommentTappng(_ sender: Any) {
        
        guard messgaeTxtView.text != "",
        let text = messgaeTxtView.text else {
            
            return
        }
        
        delegate?.updateLocalData(data: text)
        
        messgaeTxtView.text = ""
        
    }
    
}
