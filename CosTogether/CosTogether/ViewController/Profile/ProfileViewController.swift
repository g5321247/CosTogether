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
import KeychainAccess
import SDWebImage
import NotificationBannerSwift

class ProfileViewController: UIViewController {

    @IBOutlet weak var topView: TopLogoView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var aboutMyselfTextView: UITextView!
    @IBOutlet weak var editBot: UIButton!
    @IBOutlet weak var sendBot: UIButton!
    
    var userType: UserType = .currentTabProfile
    var userInfo: UserModel?
    
    let firebaseManager = FirebaseManager()
    
    var currentUserModel: UserModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setup()
    }
    
    private func setup() {

        userImageSetup(user: userType)
        topBotSetup(user: userType)
        
        aboutMyselfSetup()
        aboutMyselfEditable(editable: false)
        
        guard let userId = Auth.auth().currentUser?.uid else {
            
            return
        }
        
        firebaseManager.userIdToGetUserInfo(userId: userId) { (userModel) in
            
            self.currentUserModel = userModel
            
        }
        
    }

    func aboutMyselfEditable(editable: Bool) {
        
        aboutMyselfTextView.isEditable = editable
        
    }
    
    private func aboutMyselfSetup() {
        
        editBot.cornerSetup(cornerRadius: 4)
        sendBot.cornerSetup(cornerRadius: 4)

        aboutMyselfTextView.cornerSetup(
            cornerRadius: 0,
            borderWidth: 0.5,
            borderColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        )
        
    }
    
    private func userImageSetup(user: UserType) {

        userImage.cornerSetup(
            cornerRadius: userImage.frame.width / 2,
            borderWidth: 0.5,
            borderColor: UIColor.lightGray.cgColor
        )
        
        switch user {
        case .currentUser, .currentTabProfile:
            
            guard let currentUser = Auth.auth().currentUser else {
                
                print("user invaild")
                return
                
            }
            
            let stringUrl = currentUser.photoURL?.absoluteString ?? ""
            
            let url = URL(string: stringUrl + "?height=500")
            
            userImage.sd_setImage(with: url)
            userNameLbl.text = currentUser.displayName
            
            guard let aboutSelf = currentUserModel?.aboutSelf,
                aboutSelf != "" else {
                
                self.aboutMyselfTextView.text = "目前使用者沒有任何相關資料"
                
                return
            }
            
            self.aboutMyselfTextView.text = aboutSelf
            
        case .otherUser:
            break
            
        }
        
    }
    
    func topBotSetup(user: UserType) {
        
        switch user {
        
        case .currentTabProfile:
            
            topView.rightBot.setImage(#imageLiteral(resourceName: "logout"), for: UIControl.State.normal)

            topView.rightBot.titleLabel!.text = ""
            
            topView.leftBot.isEnabled = false
            topView.leftBot.isHidden = true
            
        case .currentUser:
            
            topView.rightBot.setImage(#imageLiteral(resourceName: "logout"), for: UIControl.State.normal)
            
            topView.rightBot.titleLabel!.text = ""
            
            topView.leftBot.isEnabled = true
            topView.leftBot.isHidden = false
            
        case .otherUser:
            
            topView.rightBot.isEnabled = true
            topView.rightBot.isHidden = false
            
            topView.leftBot.isEnabled = true
            topView.leftBot.isHidden = false

        }
        
        topView.rightBot.addTarget(self, action: #selector (self.topRigthBotTapping(_:)), for: .touchUpInside)

    }
    
    @objc func topRigthBotTapping(_ sender: UIButton) {
        
        switch userType {
            
        case .currentUser, .currentTabProfile:
            
            let alert = UIAlertController(title: "登出", message: "您是否要登出帳號？", preferredStyle: UIAlertController.Style.alert)
            
            let action = UIAlertAction(title: "確認", style: .default) { (_) in
                
                let keychain = Keychain(service: "com.george.CosTogether")
               
                do  {
                    
                    try keychain.remove(FirebaseType.uuid.rawValue)
                    
                    try Auth.auth().signOut()
                    
                    AppDelegate.shared.switchLogIn()

                } catch {
                    
                    BaseNotificationBanner.warningBanner(subtitle: "登出失敗，請確認網路")
                    return
                }
                
                
            }
            
            let cancel = UIAlertAction(title: "取消", style: .cancel)
            
            alert.addAction(cancel)
            
            alert.addAction(action)
            
            self.present(alert, animated: true, completion: nil)

        case .otherUser:
            
            reportingUser()
            
            return
        }
        
    }
    
    @IBAction func leftBotTapping(_ sender: UIButton) {
        
        navigationController?.popViewController(animated: true)       
    }
    
    func checkOtherUser(
        averageEvaluation: Double,
        userImage: String,
        buyNumber: Int,
        userName: String,
        numberOfEvaluation: Int,
        aboutSelf: String,
        userType: UserType
        ) {
        
//        averageEvaluationLbl.text = String(averageEvaluation)
        
        let url = URL(string: userImage + "?height=500")
        self.userImage.sd_setImage(with: url)
        
        
//        buyNumberLbl.text = String(buyNumber)
//        userNameLbl.text = userName
//        numberOfEvaluationLbl.text = String(numberOfEvaluation)
        
        self.userType = userType

        guard aboutSelf != "" else {
            
            self.aboutMyselfTextView.text = "目前使用者沒有任何相關資料"
            
            return
        }
        
        self.aboutMyselfTextView.text = aboutSelf

    }
    
    func reportingUser() {
        
        guard Auth.auth().currentUser?.uid != nil else {
            
            BaseNotificationBanner.warningBanner(subtitle: "匿名使用者無法檢舉其他使用者")
            
            return
        }
        
        let alert = UIAlertController(title: "檢舉使用者", message: "您將對該使用者進行檢舉，請進行確認", preferredStyle: UIAlertController.Style.alert)
        
        let action = UIAlertAction(title: "確認", style: .default) { (_) in
            
            let alert = UIAlertController(title: "已收到檢舉", message: "我們進行確認後會儘速處理", preferredStyle: UIAlertController.Style.alert)
            
            let action = UIAlertAction(title: "確認", style: .default)
            
            alert.addAction(action)
            
            self.present(alert, animated: true, completion: nil)
        }
        
        let cancel = UIAlertAction(title: "取消", style: .cancel)
        
        alert.addAction(cancel)

        alert.addAction(action)

        self.present(alert, animated: true, completion: nil)

    }
}
