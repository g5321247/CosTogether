//
//  AppDelegate.swift
//  CosTogether
//
//  Created by George Liu on 2018/9/19.
//  Copyright © 2018 George Liu. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Override point for customization after application launch.
        
        FirebaseApp.configure()
        
        FBSDKApplicationDelegate.sharedInstance().application(
            application,
            didFinishLaunchingWithOptions: launchOptions
        )
        
        switchLogIn()
        
        return true
    }
    
    // MARK: Facebook Setting
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        return FBSDKAppEvents.activateApp()
    }
    
    private func application(
        application: UIApplication,
        openURL url: URL,
        sourceApplication: String,
        annotation: Any?
        ) -> Bool {
        
        return FBSDKApplicationDelegate.sharedInstance().application(
            application,
            open: url,
            sourceApplication: sourceApplication,
            annotation: annotation
        )
    }
    
    // MARK: Switch  Setting

    func switchLogIn() {
        
       window?.rootViewController = UIStoryboard.logInStoryboard().instantiateInitialViewController()
        
    }

}
