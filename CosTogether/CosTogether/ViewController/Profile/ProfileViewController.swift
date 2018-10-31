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
    
    var temAboutMyself: AboutMyself?
    
    let firebaseManager = FirebaseManager()

    var userType: UserType = .currentTabProfile
    var currentUserModel: UserModel?

    let dispatchGroup = DispatchGroup()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        phoneTxf.delegate = self
        
        downloadUserData(user: userType, otherUserId: nil)
        setup()

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        topBotSetup(user: userType)
        userImageSetup(user: userType)
        contentBotSetup(user: userType)
    }
    
    private func setup() {

        aboutMyselfSetup()
        aboutMyselfEditable(editable: false)
        
    }
    
    // MARK: User Information
    
    private func userInfoSetup(user: UserType) {
        
        userInfoUpdate()
        descriptionSetup()
        phoneSetup()
        
    }
    
    private func descriptionSetup() {
        
        guard let description = temAboutMyself?.description,
            description != "" else {
            
            aboutMyselfTextView.text = "目前使用者沒有任何相關資料"
            
            return
        }
        
        aboutMyselfTextView.text = description
        
    }
    
    private func phoneSetup() {
        
        guard let phoneNumber = temAboutMyself?.phoneNumber else {
            
                phoneTxf.text = "請設定電話"
            
                return
        }
        
        phoneTxf.text = "\(phoneNumber)"
        
    }
    
    
    @objc func callUser(_ sender: UIButton) {
        
        guard let phoneNumber = phoneTxf.text,
           let url = URL(string: "tel://\(phoneNumber)") else {
            
            return
        }
        
        UIApplication.shared.open(url)
        
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
    
    private func userInfoUpdate() {
        
        guard let currentUser = currentUserModel else {
            
            return
        }
        
        userSetUp(userModel: currentUser)
        
    }
    
    private func userImageSetup(user: UserType) {

        userImage.cornerSetup(
            cornerRadius: userImage.frame.width / 2,
            borderWidth: 0.5,
            borderColor: UIColor.lightGray.cgColor
        )
    }
    
    private func userSetUp(userModel: UserModel) {
        
        let stringUrl = userModel.userImage
        let url = URL(string: stringUrl + "?height=500")

        userImage.sd_setImage(with: url)
        userNameLbl.text = userModel.userName
        
        temAboutMyself = userModel.aboutSelf
    }
    
    // MARK: Button Setup
    
    private func contentBotSetup(user: UserType) {
        
        switch user {
            
        case .currentTabProfile, .currentUser:
            
            editBot.titleLabel?.text = "編輯資料"
            
            editBot.addTarget(self, action: #selector (editBotTapping(_:)), for: .touchUpInside)
            
            updateAboutMyselfBot.addTarget(self, action: #selector (sendingAboutMyself(_:)), for: .touchUpInside)
            
            cancelEditBot.addTarget(self, action: #selector (cancelEditing(_:)), for: .touchUpInside)
            
        case .otherUser:
            
            editBot.titleLabel?.text = "電話聯絡"
            editBot.addTarget(self, action: #selector (callUser(_:)), for: .touchUpInside)
            
        }
        
    }
    
    private func topButton(leftIsHidden: Bool) {
        
        topView.leftBot.isHidden = leftIsHidden
        topView.leftBot.isEnabled = !leftIsHidden
        
    }
    
    private func topBotSetup(user: UserType) {
        
        switch user {
        
        case .currentTabProfile:
            
            topButton(leftIsHidden: true)
            
        case .currentUser, .otherUser:
            
            topButton(leftIsHidden: false)

        }
        
        topView.rightBot.addTarget(self, action: #selector (self.topRigthBotTapping(_:)), for: .touchUpInside)

    }
    
}

extension ProfileViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let text = textField.text else {
            
            return true
            
        }
        
        let count = text.count + string.count - range.length
        
        return count <= 10
        
    }
    
}

// MARK: Edit About Myself

extension ProfileViewController {
    
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
    
    private func aboutMyselfButton(isHidden: Bool) {
        
        updateAboutMyselfBot.isHidden = isHidden
        updateAboutMyselfBot.isEnabled = !isHidden
        
        cancelEditBot.isHidden = isHidden
        cancelEditBot.isEnabled = !isHidden
        
        aboutMyselfEditable(editable: !isHidden)
        
        editBot.isHidden = !isHidden
        
    }
    
    private func editing(_ isEditing: Bool) {
        
        guard isEditing else {
            
            aboutMyselfButton(isHidden: true)
            
            return
        }
        
        aboutMyselfButton(isHidden: false)
        
    }
    
    @objc func sendingAboutMyself(_ sender: UIButton) {
        
        SVProgressHUD.show()
        
        firebaseManager.updateAboutMyself(
            description: aboutMyselfTextView.text,
            phoneNumber: nil
        )
        
        temAboutMyself?.description = aboutMyselfTextView.text
        temAboutMyself?.phoneNumber = phoneTxf.text
        
        editing(false)
        
        guard Int(phoneTxf.text!) != nil else {

            NotificationBanner.warningBanner(subtitle: "請輸入有效電話")
            
            firebaseManager.updateAboutMyself(
                description: aboutMyselfTextView.text,
                phoneNumber: phoneTxf.text
            )

            SVProgressHUD.dismiss()

            return
        }
        
        firebaseManager.updateAboutMyself(
            description: aboutMyselfTextView.text,
            phoneNumber: phoneTxf.text
        )
        
        SVProgressHUD.dismiss()
    }
    
    @objc func cancelEditing(_ sender: UIButton) {
        
        editing(false)
        
        aboutMyselfTextView.text = temAboutMyself?.description ?? "目前使用者沒有任何相關資料"
        phoneTxf.text = temAboutMyself?.phoneNumber ?? "請設定電話"
    }

    @objc func editBotTapping(_ sender: UIButton) {
        
        editing(true)
        
    }
    
}

// MARK: Fetch User Info

extension ProfileViewController {
    
    func downloadUserData(user: UserType, otherUserId: String?) {
        
        userType = user
    
        switch user {
            
        case .currentTabProfile, .currentUser:
            
            guard let userId = Auth.auth().currentUser?.uid else {
                
                return
            }
            
            firebaseManager.userIdToGetUserInfo(userId: userId) { (userModel) in
                
                self.currentUserModel = userModel
                self.userInfoSetup(user: user)

            }

        case .otherUser:
            
            guard let userId = otherUserId else {

                return
                
            }
            
            firebaseManager.userIdToGetUserInfo(userId: userId) { (userModel) in
                
                self.currentUserModel = userModel
                self.userInfoSetup(user: user)

            }
            
        }
        
    }
    
}

// MARK: Top Button Action

extension ProfileViewController {
    
    @objc func topRigthBotTapping(_ sender: UIButton) {
        
        switch userType {
            
        case .currentUser, .currentTabProfile:
            
            logOut()
            
        case .otherUser:
            
            reportingUser()
            
        }
        
    }
    
    @IBAction func leftBotTapping(_ sender: UIButton) {
        
        navigationController?.popViewController(animated: true)
    }
    
}

// MARK: Alert Action

extension ProfileViewController {
    
    private func logOut() {
        
         let alertController =  UIAlertController.showActionSheet(
         defaultOption: ["登出"]) { (action) in
            
             let alert = UIAlertController.showAlert(
                title: "登出",
                message: "您是否要登出帳號？",
                defaultOption: ["確定"]) { (action) in
                    
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
                
                self.present(alert, animated: true, completion: nil)
            
            }
    
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func reportingUser() {
        
        guard Auth.auth().currentUser?.uid != nil else {
            
            BaseNotificationBanner.warningBanner(subtitle: "匿名使用者無法檢舉其他使用者")
            
            return
        }
        
        let alertController =  UIAlertController.showActionSheet(
        defaultOption: ["檢舉用戶", "封鎖用戶"]) { [weak self] (action) in
            
            switch action.title {
                
            case "檢舉用戶":
                
                let alert = UIAlertController.alertMessage(title: "已收到檢舉", message: "我們確認後會在 24 小時內進行處理")
                
                self?.present(alert, animated: true, completion: nil)
                
            case "封鎖用戶":
                
                let alert = UIAlertController.alertMessage(title: "成功封鎖", message: "您已封鎖該用戶，未來將不會再看到該用戶的發文和留言")

                guard let userId = self?.currentUserModel?.userId else {
                    return
                }
                
                let userDefault = UserDefaults.standard
                userDefault.set(1, forKey: userId)
                
                self?.present(alert, animated: true, completion: nil)
                
            default:
                break
                
            }
        }
        
        self.present(alertController, animated: true, completion: nil)
    }

}
