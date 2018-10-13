//
//  PreviousCommentTableViewCell.swift
//  CosTogether
//
//  Created by George Liu on 2018/9/29.
//  Copyright © 2018 George Liu. All rights reserved.
//

import UIKit
import SDWebImage

class PreviousCommentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var sendDataLbl: UILabel!
    @IBOutlet weak var commenterNameLbl: UILabel!
    @IBOutlet weak var commentLbl: UILabel!
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var commenterBot: UIButton!
    @IBOutlet weak var noCommentLbl: UILabel!
    
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
    
    func updateComment(comment: CommentModel) {

        noCommentLbl.text = ""
        
        commenterBot.isEnabled = true
        commenterBot.isHidden = false
        
        sendDataLbl.text = String(describing: comment.postDate)
        commentLbl.text = comment.comment
        
        #warning ("改成用 id fetch user")
//        commenterNameLbl.text = comment.user.userName
        
//        let userUrl = comment.user.userImage
        
//        let url = URL(string: userUrl)
        
//        commenterBot.sd_setImage(with: url, for: .normal)
    }
    
    func noCommentSetup(title: String) {
        
        sendDataLbl.text = ""
        commenterNameLbl.text = ""
        commentLbl.text = ""
        commenterBot.isEnabled = false
        commenterBot.isHidden = true
        noCommentLbl.text = title
        
    }
}
