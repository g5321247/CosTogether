//
//  TabViewController.swift
//  CosTogether
//
//  Created by George Liu on 2018/9/22.
//  Copyright © 2018 George Liu. All rights reserved.
//

import UIKit

private enum Tab {
    
    case mainPage
    
    case createGroup
    
    case joinGroup
    
    case profile
    
    func controller() -> UIViewController {
        
        switch self {
            
        case .mainPage:
            
            return UIStoryboard.mainPage().instantiateInitialViewController()!
            
        case .createGroup:
            
            return UIStoryboard.createGroup().instantiateInitialViewController()!
        
        case .joinGroup:
            
            return UIStoryboard.joinGroup().instantiateInitialViewController()!
            
        case .profile:
            
            return UIStoryboard.profile().instantiateInitialViewController()!
            
        }
    }
        
    func title() -> String {
        
        switch self {
            
        case .mainPage:
            
            return "找團 Go"
            
        case .createGroup:
            
            return "開團 Go"
            
        case .joinGroup:
            
            return "我的揪團"
            
        case .profile:
            
            return "個人資料"
            
        }
        
        
    }
        
    func image() -> UIImage {
        
        switch self {
            
        case .mainPage:
           
            return #imageLiteral(resourceName: "searching")
        
        case .createGroup:

            return #imageLiteral(resourceName: "open")

        case .joinGroup:
            
            return #imageLiteral(resourceName: "shopping")

        case .profile:
            
            return #imageLiteral(resourceName: "Profile")
            
        }
        
    }
}

class TabViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        
    }

    private func setup() {
        
        setTabBarView()
        setupTab()
    }
    
    private func setupTab() {
        
        var controllers: [UIViewController] = []
        
        let tabs: [Tab] = [.mainPage, .createGroup, .joinGroup, .profile]
        
        for tab in tabs {
            
            let controller = tab.controller()
            
            let item = UITabBarItem(
                title: tab.title(),
                image: tab.image(),
                selectedImage: tab.image()
            )
            
            controller.tabBarItem = item
            controllers.append(controller)
        }
        
        setViewControllers(controllers, animated: false)

    }
    
    private func setTabBarView() {
        
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
