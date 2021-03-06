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
import IQKeyboardManagerSwift
import Fabric
import Crashlytics
import KeychainAccess

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    // swiftlint:disable force_cast
    static let shared = UIApplication.shared.delegate as! AppDelegate
    // swiftlint:enable force_cast

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        Database.database().isPersistenceEnabled = true
        
        FBSDKApplicationDelegate.sharedInstance().application(
            application,
            didFinishLaunchingWithOptions: launchOptions
        )
        
        IQKeyboardManager.shared.enable = true
        Fabric.with([Crashlytics.self])
        
        let keychain = Keychain(service: "com.george.CosTogether")

        guard keychain[FirebaseType.uuid.rawValue] != nil else {

            switchLogIn()
            
            return true
        }
        
        switchMainPage()

        return true
    }
    
    func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey: Any] = [:]
        ) -> Bool {
        
        // FBSDK
        let handled = FBSDKApplicationDelegate.sharedInstance().application(
            app,
            open: url,
            options: options
        )
        
        return handled
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
    
    func backLoginPage() {
        
        window?.rootViewController = UIStoryboard.logInStoryboard().instantiateInitialViewController()
    }

}
