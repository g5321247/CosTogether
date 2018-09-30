//
//  ProfileViewController.swift
//  CosTogether
//
//  Created by George Liu on 2018/9/29.
//  Copyright © 2018 George Liu. All rights reserved.
//

import UIKit
import SDWebImage
import FirebaseAuth
import Firebase

class ProfileViewController: UIViewController {

    @IBOutlet weak var topView: TopLogoView!
    @IBOutlet weak var userPicBaseView: UIView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var baseViewWidth: NSLayoutConstraint!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var buyNumberLbl: UILabel!
    @IBOutlet weak var evaluationLbl: UILabel!
    @IBOutlet weak var numberOfEvaluationLbl: UILabel!

    #warning ("判斷使用者資料")
    var userType: UserType = .currentUser
    
    #warning ("改成 user struct")
    var otherUserInfo:
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setup()
    }
    
    private func setup() {
        userImageSetup(user: userType)
        userPicBaseViewSetup()
        topBottonStyle(user: userType)
    }

    private func userImageSetup(user: UserType) {

        switch user {
        case .currentUser:
            
            guard let currentUser = Auth.auth().currentUser else {
                
                print("user invaild")
                return
                
            }
            
            let stringUrl = currentUser.photoURL?.absoluteString ?? ""
            
            let url = URL(string: stringUrl + "?height=500")
            
            userImage.sd_setImage(with: url)
            userNameLbl.text = currentUser.displayName
            
        case .otherUser:
            
            return
        }

        userImage.cornerSetup(cornerRadius: userImage.frame.width / 2)
    }

    private func userPicBaseViewSetup() {
        
        baseViewWidth.constant = self.view.frame.width * (210 / 375)
        
        userPicBaseView.cornerSetup(
            cornerRadius: userPicBaseView.frame.width / 2,
            borderWidth: 0.5,
            borderColor: UIColor.lightGray.cgColor,
            maskToBounds: true
        )
        
        userPicBaseView.alpha = 0.9
        
    }
    
    func topBottonStyle(user: UserType) {
        
        topView.leftBot.isEnabled = true
        
        switch user {
            
        case .currentUser:
            
            topView.leftBot.setImage(#imageLiteral(resourceName: "logout"), for: UIControl.State.normal)
            
        case .otherUser:
            
            topView.leftBot.setImage(#imageLiteral(resourceName: "chat"), for: UIControl.State.normal)
            
        }
        
        topView.rightBot.addTarget(self, action: #selector (self.topBotton(_:)), for: .touchUpInside)

    }
    
    @objc func topBotton(_ sender: UIButton) {
        
        switch userType {
            
        case .currentUser:
            
            let domain = Bundle.main.bundleIdentifier!
            UserDefaults.standard.removePersistentDomain(forName: domain)
            
            AppDelegate.shared.switchLogIn()
        
        #warning ("跳到聊天頁面")
        case .otherUser:
            return
        }
        
    }
    
    
    
    
}
