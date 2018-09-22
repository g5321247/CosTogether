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

    // swiftlint:disable force_cast
    static let shared = UIApplication.shared.delegate as! AppDelegate
    // swiftlint:enable force_cast

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Override point for customization after application launch.
        
        FirebaseApp.configure()
        
        FBSDKApplicationDelegate.sharedInstance().application(
            application,
            didFinishLaunchingWithOptions: launchOptions
        )
        
        if UserDefaults.standard.value(forKey: FirebaseType.uuid.rawValue) != nil {

            switchMainPage()

        }
        
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
    
    // MARK: Switch Page

    func switchLogIn() {
        
       window?.rootViewController = UIStoryboard.logInStoryboard().instantiateInitialViewController()
        
    }
    
    func switchMainPage() {
        
        window?.rootViewController = UIStoryboard.mainStoryboard().instantiateInitialViewController()
    }

}
