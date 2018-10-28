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
    
    var user: UserModel?
    
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
                
        guard let user = comment.user else {
            return
        }
        commenterNameLbl.text = user.userName
        
        let userUrl = user.userImage
        
        let url = URL(string: userUrl)
        
        commenterBot.sd_setImage(with: url, for: .normal)
        
        self.user = comment.user
    }
    
    func noCommentSetup(title: String) {
        
        sendDataLbl.text = ""
        commenterNameLbl.text = ""
        commentLbl.text = ""
        commenterBot.isEnabled = false
        commenterBot.isHidden = true
        noCommentLbl.text = title
        
    }
    
    @IBAction func clickUserPic(_ sender: UIButton) {
        
        guard  let user = user else {
            return
        }
        
        guard let controller = UIStoryboard.profile().instantiateViewController(
            withIdentifier: String(describing: ProfileViewController.self)
            ) as? ProfileViewController else {
                
                return
                
        }
        
        controller.loadViewIfNeeded()
        
        controller.checkOtherUser(
            averageEvaluation: user.averageEvaluation ?? 0,
            userImage: user.userImage,
            buyNumber: user.buyNumber ?? 0,
            userName: user.userName,
            numberOfEvaluation: user.numberOfEvaluation ?? 0,
            aboutSelf: user.aboutSelf,
            userId: user.userId ?? "",
            userType: .otherUser
        )
        
    }
    
}
