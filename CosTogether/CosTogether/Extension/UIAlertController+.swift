//
//  UIAlertController.swift
//  CosTogether
//
//  Created by George Liu on 2018/9/20.
//  Copyright © 2018 George Liu. All rights reserved.
//

import UIKit

extension UIAlertController {
    
    private static func alertMessage(
        title: String? = "錯誤",
        message: String,
        preferredStyle: UIAlertController.Style? = UIAlertController.Style.alert
        ) -> UIAlertController {
        
    let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle!)
        
        let action = UIAlertAction(title: "確定", style: .default, handler: nil)

        alert.addAction(action)
        
        return alert
    }
    
    static func errorMessage(errorType: ErrorComment) -> UIAlertController {

       return alertMessage(message: errorType.errorMessage())
        
    }
    
    static func orderMessage(title: String, message: String) -> UIAlertController {
        
        return alertMessage(title: title, message: message)
    }

}
