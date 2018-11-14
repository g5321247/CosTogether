//
//  UserManager.swift
//  CosTogether
//
//  Created by George Liu on 2018/11/9.
//  Copyright © 2018 George Liu. All rights reserved.
//

import Foundation
import Firebase
import KeychainAccess

struct UserInfo {
    
    var userId: String
    var userName: String
    var userPicURL: String
    
}


class UserManager {
    
    static let shared = UserManager()
    
    lazy var user: UserInfo? = {
        
        guard let user = Auth.auth().currentUser,
            let userName = user.displayName,
            let userPicURL = user.photoURL?.absoluteString else {
            
                return nil
            
            }
        
            return UserInfo(userId: user.uid, userName: userName, userPicURL: userPicURL)

    }()
    
    private init() {}
    
    func userInfo() -> UserInfo? {

        guard let user = Auth.auth().currentUser,
            let userName = user.displayName,
            let userPicURL = user.photoURL?.absoluteString else {

                return nil

        }

        return UserInfo(userId: user.uid, userName: userName, userPicURL: userPicURL)

    }
    
    func signOut(sucess: () -> Void, failure: () -> Void) {
        
        do  {
            
            try Auth.auth().signOut()

            let keychain = Keychain(service: "com.george.CosTogether")
            try keychain.remove(FirebaseType.uuid.rawValue)

            sucess()
            
        } catch {
            
            failure()
            
        }

    }
    
}
