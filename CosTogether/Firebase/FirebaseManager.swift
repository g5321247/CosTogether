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
    
    func update() {
    
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
