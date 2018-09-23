//
//  TabViewController.swift
//  CosTogether
//
//  Created by George Liu on 2018/9/22.
//  Copyright © 2018 George Liu. All rights reserved.
//

import UIKit

class TabViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTabBar()
    }
    
    func setTabBar() {
        
        // MARK: Tabbar shadow
        
        let tabGradientView = UIView(frame: self.tabBar.bounds)
        tabGradientView.backgroundColor = UIColor.white
        
        tabGradientView.translatesAutoresizingMaskIntoConstraints = false
    
        self.tabBar.addSubview(tabGradientView)
        self.tabBar.sendSubviewToBack(tabGradientView)
        tabGradientView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        tabGradientView.layer.shadowOffset = CGSize(width: 0, height: 0)
        tabGradientView.layer.shadowRadius = 4.0
        tabGradientView.layer.shadowColor = UIColor.lightGray.cgColor
        tabGradientView.layer.shadowOpacity = 0.6
        
        self.tabBar.clipsToBounds = false
        self.tabBar.backgroundImage = UIImage()
        self.tabBar.shadowImage = UIImage()
        
    }
    
}
