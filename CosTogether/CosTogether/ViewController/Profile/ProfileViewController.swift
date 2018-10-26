//
//  ProfileViewController.swift
//  CosTogether
//
//  Created by George Liu on 2018/9/29.
//  Copyright © 2018 George Liu. All rights reserved.
//

import UIKit
import SVProgressHUD
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
    @IBOutlet weak var updateAboutMyselfBot: UIButton!
    @IBOutlet weak var cancelEditBot: UIButton!
    @IBOutlet weak var editBot: UIButton!
    @IBOutlet weak var phoneTxf: UITextField!
    
    var temAboutMyself: String?
    var temPhone: String?
    
    let firebaseManager = FirebaseManager()

    var userType: UserType = .currentTabProfile
    var userInfo: UserModel?
    var currentUserModel: UserModel?

    let dispatchGroup = DispatchGroup()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        downloadUserData()
        
    }
    
    override func viewDidLayoutSubviews() {
        
        setup()
        userImageSetup(user: userType)

    }
    
    private func setup() {

        topBotSetup(user: userType)
        contentBotSetup(user: userType)
        
        aboutMyselfSetup()
        aboutMyselfEditable(editable: false)
        
    }
    
    private func downloadUserData() {
        
        guard let userId = Auth.auth().currentUser?.uid else {
            
            return
        }
        
        firebaseManager.userIdToGetUserInfo(userId: userId) { [weak self] (userModel) in
            
            self?.currentUserModel = userModel
            
            guard userModel.aboutSelf != "" else {
                return
            }
            
            self?.dispatchGroup.enter()
            self?.temAboutMyself = userModel.aboutSelf
            self?.dispatchGroup.leave()
        }

        
    }
    
    private func contentBotSetup(user: UserType) {
        
        switch user {
            
        case .currentTabProfile, .currentUser:
            
            editBot.titleLabel?.text = "編輯資料"
            
            editBot.addTarget(self, action: #selector (editBotTapping(_:)), for: .touchUpInside)
            
            updateAboutMyselfBot.addTarget(self, action: #selector (sendingAboutMyself(_:)), for: .touchUpInside)
            
            cancelEditBot.addTarget(self, action: #selector (cancelEditing(_:)), for: .touchUpInside)
            
        case .otherUser:
            
            editBot.titleLabel?.text = "電話聯絡"

        }
        
    }
    
    @objc func callUser(_ sender: UIButton) {
        
        guard let phoneNumber = Int(phoneTxf.text!),
           let url = URL(string: "tel://\(phoneNumber)") else {
            
            return
        }
        
        UIApplication.shared.open(url)
        
    }
    
    @objc func editBotTapping(_ sender: UIButton) {
        
        editing(true)
        
    }
    
    @objc func sendingAboutMyself(_ sender: UIButton) {
        
        SVProgressHUD.show()
        
        firebaseManager.updateAboutMyself(description: aboutMyselfTextView.text)
        
        temAboutMyself = aboutMyselfTextView.text
        
        editing(false)
        
        SVProgressHUD.dismiss()
    }
    
    @objc func cancelEditing(_ sender: UIButton) {
        
        editing(false)
        
        aboutMyselfTextView.text = temAboutMyself ?? "目前使用者沒有任何相關資料"
        
    }
    
    private func editing(_ isEditing: Bool) {
        
        guard isEditing else {
            
            updateAboutMyselfBot.isHidden = true
            updateAboutMyselfBot.isEnabled = false
            
            cancelEditBot.isHidden = true
            cancelEditBot.isEnabled = false
            
            phoneTxf.isEnabled = false
            
            aboutMyselfEditable(editable: false)
            
            return
        }
        
        updateAboutMyselfBot.isHidden = false
        updateAboutMyselfBot.isEnabled = true
        
        cancelEditBot.isHidden = false
        cancelEditBot.isEnabled = true
        
        aboutMyselfEditable(editable: true)

    }

    private func aboutMyselfEditable(editable: Bool) {
        
        aboutMyselfTextView.isEditable = editable
        phoneTxf.isEnabled = editable
        
        guard editable else {
            
            phoneTxf.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            aboutMyselfTextView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            
            return
        }
        
        phoneTxf.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        aboutMyselfTextView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        
    }
    
    private func aboutMyselfSetup() {
        
        updateAboutMyselfBot.cornerSetup(cornerRadius: 4)
        cancelEditBot.cornerSetup(cornerRadius: 4)
        editBot.cornerSetup(cornerRadius: 4)
        
        phoneTxf.cornerSetup(
            cornerRadius: 4,
            borderWidth: 1,
            borderColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        )
        
        
        aboutMyselfTextView.cornerSetup(
            cornerRadius: 4,
            borderWidth: 1,
            borderColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
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
            
            dispatchGroup.notify(queue: .main) {
                
                guard let temAboutMyself = self.temAboutMyself else {
                    return
                }
                
                self.aboutMyselfTextView.text = temAboutMyself

            }

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
            
            topView.rightBot.setImage(#imageLiteral(resourceName: "menu"), for: UIControl.State.normal)

            topView.rightBot.titleLabel!.text = ""
            
            topView.leftBot.isEnabled = false
            topView.leftBot.isHidden = true
            
        case .currentUser:
            
            topView.rightBot.setImage(#imageLiteral(resourceName: "menu"), for: UIControl.State.normal)
            
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
            
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
            
            let logOut = UIAlertAction(title: "登出", style: .default) { (_) in
                
                let logoutAlert = UIAlertController(title: "登出", message: "您是否要登出帳號？", preferredStyle: UIAlertController.Style.alert)
                
                let action = UIAlertAction(title: "確認", style: .default) { (_) in
                    
                    let keychain = Keychain(service: "com.george.CosTogether")
                    
                    do  {
                        
                        try keychain.remove(FirebaseType.uuid.rawValue)
                        
                        try keychain.remove("anonymous")
                        
                        try Auth.auth().signOut()
                        
                        AppDelegate.shared.switchLogIn()
                        
                    } catch {
                        
                        BaseNotificationBanner.warningBanner(subtitle: "登出失敗，請確認網路")
                        return
                    }
                    
                    
                }
                
                let cancel = UIAlertAction(title: "取消", style: .cancel)
                cancel.setValue(UIColor.red, forKey: "titleTextColor")

                logoutAlert.addAction(cancel)
                
                logoutAlert.addAction(action)
                
                self.present(logoutAlert, animated: true, completion: nil)

            }
            
            let cancel = UIAlertAction(title: "取消", style: .cancel)
            cancel.setValue(UIColor.red, forKey: "titleTextColor")
            
            alert.addAction(logOut)
            alert.addAction(cancel)
            
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
        cancel.setValue(UIColor.red, forKey: "titleTextColor")

        alert.addAction(cancel)
        alert.addAction(report)
        
        alert.addAction(blockUser)
        
        self.present(alert, animated: true, completion: nil)

    }
}
