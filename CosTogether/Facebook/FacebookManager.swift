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

class FacebookManager {
    
    static let shared = FacebookManager()
    
    let facebookManager = FBSDKLoginManager()
    
    private init() {}
    
    func facebookLogIn(
        fromController: UIViewController? = nil,
        sucess: @escaping (String) -> Void,
        failure: @escaping (ErrorComment) -> Void
        ) {
        
        facebookManager.logIn(
            withReadPermissions: [
            PermissionKey.publicProfile.rawValue
            ],
            from: fromController) { (result, error) in
            
            guard error == nil else {
                
                failure(FBError.system(error!.localizedDescription))
                return
                
            }

            guard let fbResult = result else {
                
                failure(FBError.unrecognized("no such facebook data"))
                
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
    
    func facebookLogOut() {
        
        facebookManager.logOut()
        
    }

}
