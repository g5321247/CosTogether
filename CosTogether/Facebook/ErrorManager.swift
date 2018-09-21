//
//  ErrorManager.swift
//  CosTogether
//
//  Created by George Liu on 2018/9/21.
//  Copyright © 2018 George Liu. All rights reserved.
//

import Foundation

protocol ErrorComment: Error {
    
    func errorMessage() -> String
    
}

enum FBError: ErrorComment {
    
    case system(String)
    case unrecognized(String)
    case cancelled
    case permissionDeclined
    
    func errorMessage() -> String {
        
        switch self {
            
        case .system(let message):
            return message
        
        case .cancelled:
            return "用戶取消登入"
            
        case .permissionDeclined:
            return "請允許開放存取 Facebook 個人資料"
        
        case .unrecognized(let message):
            return message
        }
        
    }

}

enum FirebaseError: ErrorComment {
    
    case system(String)
    case unrecognized(String)
    
    func errorMessage() -> String {
        
        switch self {
            
        case .system(let message):
            return message
            
        case .unrecognized(let message):
            return message
        }
        
    }

}

