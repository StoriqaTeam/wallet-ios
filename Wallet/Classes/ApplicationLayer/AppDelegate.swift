//
//  AppDelegate.swift
//  Wallet
//
//  Created by Storiqa on 15.08.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//
// swiftlint:disable line_length

import UIKit
import AlamofireNetworkActivityIndicator
import FBSDKLoginKit
import GoogleSignIn
import CryptoSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    private let app = Application()
    
    private lazy var configurators: [Configurable] = {
        return [
            ApplicationConfigurator(app: app),
            CrashTrackerConfigurator(),
            SessionsConfigurator(app: app)
        ]
    }()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        for configurator in configurators {
            configurator.configure()
        }
        
        return true
    }
    
    
    func applicationWillEnterForeground(_ application: UIApplication) {
         app.appLockerProvider.autolock()
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        app.appLockerProvider.setLock()
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        
        let urlStr = url.absoluteString
        if urlStr.contains(Constants.NetworkAuth.kFacebookAppId) {
            return FBSDKApplicationDelegate.sharedInstance().application(app, open: url, options: options)
        } else if urlStr.contains(Constants.NetworkAuth.kGoogleClientId) {
            return GIDSignIn.sharedInstance().handle(url as URL?,
                                                     sourceApplication: options[.sourceApplication] as? String,
                                                     annotation: options[.annotation])
            
        }
        
        return true
    }
    
    
    // MARK: - Handle universal links
    func application(_ application: UIApplication,
                     continue userActivity: NSUserActivity,
                     restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        guard let link = UniversalLinkParser().parse(link: userActivity.webpageURL) else {
            return false
        }
        
        switch link {
        case .verifyEmail(let token):
            EmailConfirmModule.create(app: app, token: token).present()
        case .resetPassword(let token):
            PasswordRecoveryConfirmModule.create(app: app, token: token).present()
        case .registerDevice(let token):
            DeviceRegisterConfirmModule.create(app: app, token: token).present()
        }
        
        return true
    }
    
}


extension AppDelegate {
    
    static var currentDelegate: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    static var currentWindow: UIWindow {
        return currentDelegate.window!
    }
    
    static var currenctApplication: UIApplication {
        return UIApplication.shared
    }
}
