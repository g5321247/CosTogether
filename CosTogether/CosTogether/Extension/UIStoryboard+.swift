//
//  UIStoryboard.swift
//  CosTogether
//
//  Created by George Liu on 2018/9/19.
//  Copyright © 2018 George Liu. All rights reserved.
//

import UIKit

extension UIStoryboard {
    
    static func logInStoryboard() -> UIStoryboard {
        
        return UIStoryboard(name: "LogIn", bundle: nil)

    }
    
    static func mainStoryboard() -> UIStoryboard {
        
        return UIStoryboard(name: "Main", bundle: nil)
        
    }
    
    static func chatRoomStoryboard() -> UIStoryboard {
        
        return UIStoryboard(name: "ChatRoom", bundle: nil)
    }
 
    static func detailStoryboard() -> UIStoryboard {
        
        return UIStoryboard(name: "Detail", bundle: nil)
        
    }
    
    static func appendProductItemStoryboard() -> UIStoryboard {
        
        return UIStoryboard(name: "AppendProductItem", bundle: nil)
    }
}
