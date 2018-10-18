//
//  SendCommentTableViewCell.swift
//  CosTogether
//
//  Created by George Liu on 2018/9/29.
//  Copyright © 2018 George Liu. All rights reserved.
//

import UIKit
import Firebase
import NotificationBannerSwift

class SendCommentTableViewCell: UITableViewCell {

    @IBOutlet weak var baseView: MessageView!
    
    weak var delegate: CellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        baseView.messgaeTxtView.delegate = self
        
        guard Auth.auth().currentUser?.uid != nil else {
            
            baseView.sendMessageBot.isEnabled = false
            
            return
        }
        
        baseView.sendMessageBot.isEnabled = true
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func resizeTextView(heightGap: CGFloat) {
        
        delegate?.resizing(heightGap: heightGap)
        
    }
        
}

extension SendCommentTableViewCell: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if textView.textColor == UIColor.lightGray {

            textView.text = nil
            textView.textColor = UIColor.black

        }
        
        guard Auth.auth().currentUser?.uid != nil else {
            BaseNotificationBanner.warningBanner(subtitle: "匿名使用者無法送出留言，請用 FB 登入")
            
            return
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
        
        if baseView.messgaeTxtView.contentSize.height > baseView.messgaeTxtView.frame.size.height {
            
            let heightGap = newSize.height - baseView.messgaeTxtView.frame.size.height
            
            self.frame.size.height += heightGap

            baseView.messgaeTxtView.frame.size.height = newSize.height
            baseView.frame.size.height += heightGap

            delegate?.resizing(heightGap: heightGap)

        }

    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        
        self.adjustTextViewHeight()
        
    }
    
}
