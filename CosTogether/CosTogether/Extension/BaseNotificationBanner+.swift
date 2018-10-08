//
//  BaseNotificationBanner+.swift
//  CosTogether
//
//  Created by George Liu on 2018/10/7.
//  Copyright © 2018 George Liu. All rights reserved.
//

import Foundation
import NotificationBannerSwift

extension BaseNotificationBanner {
    
    static func warningBanner(
        title: String = "警告",
        subtitle: String,
        style: BannerStyle = .warning
        ) {
        
        let banner = NotificationBanner(title: title, subtitle: subtitle, style: style)
        
        banner.show()

    }
    

}