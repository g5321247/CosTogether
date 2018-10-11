//
//  FirebaseManager.swift
//  CosTogether
//
//  Created by George Liu on 2018/9/20.
//  Copyright © 2018 George Liu. All rights reserved.
//

import Foundation
import Firebase
import KeychainAccess

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
                
                guard let refrence = AppDelegate.shared.ref else {
                    return
                }
                
                refrence.child("users").child(user.uid).child("userInfo").setValue(
                    [
                    "username": userInfo.userName,
                    "userPicUrl" : userInfo.userPicUrl
                    ]
                )
                
                let keychain = Keychain(service: "com.george.CosTogether")
                keychain[FirebaseType.uuid.rawValue] = user.uid
                
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
        
      
        
//        let userInfo = UserInfo(userName: user.displayName!, userPicUrl: user.photoURL!.absoluteString)
//
//        let post = [
//            "userName": userInfo.userName,
//            "userPicUrl": userInfo.userPicUrl,
//            ] as [String : Any]
//
//        AppDelegate.shared.ref.updateChildValues(["/user/\(user.uid)/": post])
        
        
    }
    
    func uploadGroup(group: Group) {
        
        guard let refrence = AppDelegate.shared.ref else {
            return
        }
        
        guard let key = refrence.child("group").child(group.openType.rawValue).childByAutoId().key else {
            
            #warning ("上傳失敗警告")
            
            return
        }
        
        refrence.child("\(group.openType.rawValue)").child("\(key)").setValue(
            [
                "ownerId": group.userID,
                ]
        )
        
        articleSetup(refrence: refrence, key: key, group: group)
        
        
    }
    
}


extension FirebaseManager {
    
    func articleSetup(refrence: DatabaseReference, key: String, group: Group) {
        
        refrence.child("group").child("\(group.openType.rawValue)").child("\(key)").child("article").setValue(
            
            [
                "title": group.article.articleTitle,
                "location" : group.article.location,
                "postDate": group.article.postDate
            ]
            
        )
    }
    
    
}
