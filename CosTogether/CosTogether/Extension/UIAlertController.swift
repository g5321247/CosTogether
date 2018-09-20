//
//  UIAlertController.swift
//  CosTogether
//
//  Created by George Liu on 2018/9/20.
//  Copyright © 2018 George Liu. All rights reserved.
//

import UIKit

extension UIAlertController {
    
    static func alertMessage(
        title: String? = "錯誤",
        message: String,
        preferredStyle: UIAlertController.Style? = UIAlertController.Style.alert
        ) -> UIAlertController {
        
    let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle!)
        
        let action = UIAlertAction(title: "確定", style: .default, handler: nil)

        alert.addAction(action)
        
        return alert
    }
    
    static func errorMessage(errorType: FBError) -> UIAlertController {
        
//        if let fbError = errorType as? FBError {
        
            switch errorType {
                
            case .system(let message):
                
                return alertMessage(message: message)
                
            case .unrecognized(let message):
                
                return alertMessage(message: message)
                
            case .permissionDeclined:
                
                return alertMessage(message: "請允許開放存取 Facebook 個人資料")
                
            case .cancelled:
                
                return alertMessage(message: "用戶取消登入")
                
            }
            
//                if let firebaseError = errorType as? FirebaseError {
//
//                    switch firebaseError {
//
//                    case .system(let message):
//
//                        return alertMessage(message: message)
//
//                    case .unrecognized(let message):
//
//                        return alertMessage(message: message)
//
//                    }
//
//            }
//
//
//        }
//
//        return UIAlertController()
    }

}
