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
    @IBOutlet weak var authorImage: UIImageView!
        
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setup()
        messgaeTxtView.delegate = self
    }
    
    private func setup() {
        
        setupImageView()
    }
    
    private func setupImageView() {
        
        messgaeTxtView.cornerSetup(cornerRadius: 4)
        messgaeTxtView.text = "留下你的意見"
        messgaeTxtView.textColor = UIColor.lightGray
        
        authorImage.cornerSetup(cornerRadius: authorImage.frame.width / 2)
    }
    
}

extension MessageView: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if textView.textColor == UIColor.lightGray {
            
            textView.text = nil
            textView.textColor = UIColor.black
            
        }
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if textView.text.isEmpty {
            
            textView.text = "留下你的意見"
            textView.textColor = UIColor.lightGray
            
        }
        
    }
    
    func adjustTextViewHeight() {
        
        let fixedWidth = messgaeTxtView.frame.size.width
        let newSize = messgaeTxtView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        self.textHeightConstraint.constant = newSize.height
        
        self.layoutIfNeeded()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        self.adjustTextViewHeight()
    }

}
