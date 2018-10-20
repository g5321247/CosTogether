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
    
    @objc func topLeftBotTapping(_ sender: UIButton) {
        
        
        
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
        userId: String,
        userType: UserType
        ) {
        
//        averageEvaluationLbl.text = String(averageEvaluation)
        
        userInfo = UserModel(
            userImage: userImage,
            userName: userName,
            numberOfEvaluation: numberOfEvaluation,
            buyNumber: buyNumber,
            averageEvaluation: averageEvaluation,
            aboutSelf: aboutSelf,
            userId: userId
        )
        
        let url = URL(string: userImage + "?height=500")
        self.userImage.sd_setImage(with: url)
        
        userNameLbl.text = userName
        
//        buyNumberLbl.text = String(buyNumber)
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
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        
        let report = UIAlertAction(title: "檢舉用戶", style: .default) { (_) in
            
            let alert = UIAlertController(title: "已收到檢舉", message: "我們確認後會在 24 小時內進行處理", preferredStyle: UIAlertController.Style.alert)
            
            let action = UIAlertAction(title: "確認", style: .default)
            
            alert.addAction(action)
            
            self.present(alert, animated: true, completion: nil)
        }
        
        let blockUser = UIAlertAction(title: "封鎖用戶", style: .default) { (_) in
            
            let alert = UIAlertController(title: "成功封鎖", message: "您已封鎖該用戶，未來將不會再看到該用戶的發文和留言", preferredStyle: UIAlertController.Style.alert)
            
            let action = UIAlertAction(title: "確認", style: .default)
            
            guard let userId = self.userInfo?.userId else {
                return
            }
            
            let userDefault = UserDefaults.standard
            userDefault.set(1, forKey: userId)
            
            alert.addAction(action)
            
            self.present(alert, animated: true, completion: nil)
        }

        
        let cancel = UIAlertAction(title: "取消", style: .cancel)
        
        alert.addAction(cancel)

        alert.addAction(report)
        
        alert.addAction(blockUser)
        
        self.present(alert, animated: true, completion: nil)

    }
}
