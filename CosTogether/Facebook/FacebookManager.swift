//
//  FacebookManager.swift
//  CosTogether
//
//  Created by George Liu on 2018/9/20.
//  Copyright © 2018 George Liu. All rights reserved.
//

import Foundation
import FBSDKLoginKit

enum PermissionKey: String {
    
    case email
    case publicProfile = "public_profile"
    
}

enum FBError: Error {
    
    case system(String)
    case unrecognized(String)
    case cancelled
    case permissionDeclined
    
}

struct FacebookManager {
    
    let facebookManager = FBSDKLoginManager()
    
    func facebookLogIn(
        fromController: UIViewController? = nil,
        sucess: @escaping (String) -> Void,
        failure: @escaping (Error) -> Void
        ) {
        
        facebookManager.logIn(
            withReadPermissions: [
            PermissionKey.email.rawValue,
            PermissionKey.publicProfile.rawValue
            ],
            from: fromController) { (result, error) in
            
            guard error == nil else {
                
                failure(FBError.system(error!.localizedDescription))
                return
                
            }
            
            guard let fbResult = result else {
                
                failure(FBError.unrecognized("FB data lost"))
                
                return
            }
            
            guard fbResult.isCancelled == false else {
                
                failure(FBError.cancelled)
                
                return
            }
            
            guard fbResult.declinedPermissions.count == 0 else {
                
                failure(FBError.permissionDeclined)
                
                return
                
            }
            
            sucess(fbResult.token.tokenString)

        }
        
    }
    
}
