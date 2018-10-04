//
//  SendCommentTableViewCell.swift
//  CosTogether
//
//  Created by George Liu on 2018/9/29.
//  Copyright © 2018 George Liu. All rights reserved.
//

import UIKit

class SendCommentTableViewCell: UITableViewCell {

    @IBOutlet weak var baseView: MessageView!
    
    weak var delegate: CellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        baseView.messgaeTxtView.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func reloadTextViewIfNeed() {
        
        delegate?.reloadData()
        
    }
    
}

extension SendCommentTableViewCell: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if textView.textColor == UIColor.lightGray {
            
            textView.text = nil
            textView.textColor = UIColor.black
            
        }
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if textView.text.isEmpty {
            
            textView.text = "跟主揪說點什麼吧..."
            textView.textColor = UIColor.lightGray
            
        }
        
    }
    
    func adjustTextViewHeight() {
        
        let fixedWidth = baseView.messgaeTxtView.frame.size.width
        
        let newSize = baseView.messgaeTxtView.sizeThatFits(
            CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude)
            )
        
        baseView.textHeightConstraint.constant = newSize.height
        
        self.layoutIfNeeded()
        
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        self.adjustTextViewHeight()
        
//        if textView.contentSize.height > textView.frame.size.height {
//
//            reloadTextViewIfNeed()
//
//        }

    }
    
}
