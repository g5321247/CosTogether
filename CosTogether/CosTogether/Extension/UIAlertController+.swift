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
        message: String
        ) -> UIAlertController {
        
    let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
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
    
    static func showAlert(
        title: String?,
        message: String?,
        defaultOption: [String],
        defalutCompletion: @escaping (UIAlertAction) -> Void
        ) -> UIAlertController {
        
        let alerController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        
        let action = UIAlertAction(
            title: "取消",
            style: .cancel,
            handler: nil
        )
        
        alerController.addAction(action)
        
        action.setValue(UIColor.red, forKey: "titleTextColor")
        
        for item in defaultOption {
            
            let action = UIAlertAction(
                title: item,
                style: .default) { (action) in
                    
                    defalutCompletion(action)
                    
            }
            
            alerController.addAction(action)
            
        }
        
        return alerController
        
    }
    
    static func showActionSheet(
        defaultOption: [String],
        images: [UIImage]? = nil,
        defalutCompletion: @escaping (UIAlertAction) -> Void
        ) -> UIAlertController {
        
        let alerController = UIAlertController(
            title: nil,
            message: nil,
            preferredStyle: .actionSheet
        )
        
        let action = UIAlertAction(
            title: "取消",
            style: .cancel,
            handler: nil
        )
        
        alerController.addAction(action)
        
        action.setValue(UIColor.red, forKey: "titleTextColor")
        
        for (index, item) in defaultOption.enumerated() {
            
            let action = UIAlertAction(
                title: item,
                style: .default) { (action) in
                
                    defalutCompletion(action)
                
            }
            
            if images?[index] != nil {
                
                action.setValue(images![index], forKey: "image")
            }
            
            alerController.addAction(action)
            
        }

        return alerController
    }
    
}
