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

class ProfileViewController: UIViewController {

    @IBOutlet weak var topView: TopLogoView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var buyNumberLbl: UILabel!
    @IBOutlet weak var averageEvaluationLbl: UILabel!
    @IBOutlet weak var numberOfEvaluationLbl: UILabel!
    @IBOutlet weak var evaluateButton: UIButton!
    @IBOutlet weak var reportUserBot: UIButton!
    
    var userType: UserType = .currentUser
    #warning ("userInfo == current 的 uuid 時，才為 current user")
    var userInfo: UserModel?
    
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
        evaluateButtonSetup()
            
    }

    private func evaluateButtonSetup() {
        
        evaluateButton.cornerSetup(cornerRadius: evaluateButton.frame.width / 2)
        
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
            
            reportUserBot.isHidden = false
            reportUserBot.isEnabled = true

            
        }
        
        #warning ("個人資料比例")
//        let width = self.view.frame.width * (210 / 375)

//        userImage.frame.size = CGSize(width: width, height: width)
        
        userImage.cornerSetup(
            cornerRadius: userImage.frame.width / 2,
            borderWidth: 0.5,
            borderColor: UIColor.lightGray.cgColor
        )
    }
    
    func topBotSetup(user: UserType) {
        
        switch user {
            
        case .currentUser:
            
            topView.rightBot.setImage(#imageLiteral(resourceName: "logout"), for: UIControl.State.normal)
            
            topView.leftBot.isEnabled = false
            topView.leftBot.isHidden = true
            
        case .otherUser:
            
            topView.rightBot.isEnabled = false
            topView.rightBot.isHidden = true
            topView.rightBot.setImage(#imageLiteral(resourceName: "chat"), for: UIControl.State.normal)
            
            topView.leftBot.isEnabled = true
            topView.leftBot.isHidden = false

        }
        
        topView.rightBot.addTarget(self, action: #selector (self.topRigthBotTapping(_:)), for: .touchUpInside)

    }
    
    @objc func topRigthBotTapping(_ sender: UIButton) {
        
        switch userType {
            
        case .currentUser:
            
            let alert = UIAlertController(title: "登出", message: "您是否要登出帳號？", preferredStyle: UIAlertController.Style.alert)
            
            let action = UIAlertAction(title: "確認", style: .default) { (_) in
                
                let keychain = Keychain(service: "com.george.CosTogether")
                keychain[FirebaseType.uuid.rawValue] = nil
                
                AppDelegate.shared.switchLogIn()
                
            }
            
            let cancel = UIAlertAction(title: "取消", style: .cancel)
            
            alert.addAction(cancel)
            
            alert.addAction(action)
            
            self.present(alert, animated: true, completion: nil)

        #warning ("跳到聊天頁面")
        case .otherUser:
            
            guard let controller = UIStoryboard.chatRoomStoryboard().instantiateViewController(
                withIdentifier: String(describing: ChatRoomViewController.self)
                ) as? ChatRoomViewController else {
                    
                    return
                    
            }
            
            show(controller, sender: nil)
            
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
        userType: UserType
        ) {
        
        averageEvaluationLbl.text = String(averageEvaluation)
        
        let url = URL(string: userImage + "?height=500")
        self.userImage.sd_setImage(with: url)
        
        buyNumberLbl.text = String(buyNumber)
        userNameLbl.text = userName
        numberOfEvaluationLbl.text = String(numberOfEvaluation)
        self.userType = userType
    }
    
    @IBAction func reportingUser(_ sender: UIButton) {
        
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
