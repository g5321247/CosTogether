//
//  FirebaseManager.swift
//  CosTogether
//
//  Created by George Liu on 2018/9/20.
//  Copyright © 2018 George Liu. All rights reserved.
//

import Foundation
import FirebaseCore
import FirebaseAuth

struct UserInfo {
    
    var userName: String
    var userPicUrl: URL

}

enum FirebaseError: Error {
    
    case system(String)
    case unrecognized(String)
    
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
                let userInfo = UserInfo(userName: user.displayName!, userPicUrl: user.photoURL!)
                
                sucess(userInfo)
                
        }
    }
    
}
