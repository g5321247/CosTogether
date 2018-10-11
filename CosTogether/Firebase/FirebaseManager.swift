//
//  FirebaseManager.swift
//  CosTogether
//
//  Created by George Liu on 2018/9/20.
//  Copyright © 2018 George Liu. All rights reserved.
//

import Foundation
import Firebase

struct UserInfo {
    
    var userName: String
    var userPicUrl: String

}

enum FirebaseType: String {
    
    case uuid
    
}

struct FirebaseManager {
    
    func logInFirebase(
        token: String,
        sucess: @escaping (UserInfo) -> Void,
        faliure: @escaping (Error) -> Void
        ) {
        
            let credential = FacebookAuthProvider.credential(withAccessToken: token)
        
            Auth.auth().signInAndRetrieveData(
            with: credential) { (authResult, error) in
            
                guard error == nil else {
                    
                    faliure(FirebaseError.system(error!.localizedDescription))
                    
                    return
                    
                }
                
                guard let firebaseResult = authResult else {
                    
                    faliure(FirebaseError.unrecognized("No Firebase Data"))
                    
                    return
                    
                }
                
                let user = firebaseResult.user
                let userInfo = UserInfo(userName: user.displayName!, userPicUrl: user.photoURL!.absoluteString)
                
                AppDelegate.shared.ref.child("users/\(user.uid)/userInfo/username").setValue(userInfo.userName)
                AppDelegate.shared.ref.child("users/\(user.uid)/userInfo/userPicUrl").setValue(userInfo.userPicUrl)
                
                UserDefaults.standard.set(user.uid, forKey: FirebaseType.uuid.rawValue)

                sucess(userInfo)
                
        }
    }
    
    func uploadProductPics(
        articleTitle: String,
        productName: String,
        picture: Data,
        sucess: @escaping (URL) -> Void,
        faliure: @escaping (Error) -> Void
        ) {


        let storageRef = AppDelegate.shared.storage.child("group").child((Auth.auth().currentUser?.uid)!).child(articleTitle).child(productName)
        
        storageRef.putData(picture, metadata: nil) { (data, error) in
            
            guard error == nil else {

                faliure((FirebaseError.system(error!.localizedDescription)))
                return
            }
            
            storageRef.downloadURL(completion: { (url, error) in
                
                guard error == nil else {
                    
                    faliure((FirebaseError.system(error!.localizedDescription)))
                    return
                }

                guard let url = url else {
                    
                    faliure((FirebaseError.uploadPicFail("上傳照片失敗")))
                    return
                }
                
                sucess(url)
                
            })
            
        }
        
        func uploadGroup(group: group) {
            
            
            
        }
        
//        let userInfo = UserInfo(userName: user.displayName!, userPicUrl: user.photoURL!.absoluteString)
//
//        let post = [
//            "userName": userInfo.userName,
//            "userPicUrl": userInfo.userPicUrl,
//            ] as [String : Any]
//
//        AppDelegate.shared.ref.updateChildValues(["/user/\(user.uid)/": post])
        
        
    }
    
    
}
