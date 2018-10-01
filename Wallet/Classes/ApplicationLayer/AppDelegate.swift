//
//  AppDelegate.swift
//  Wallet
//
//  Created by Storiqa on 15.08.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit
import AlamofireNetworkActivityIndicator
import FBSDKLoginKit
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    private var configurators: [Configurable] = {
        return [
                ApplicationConfigurator(keychain: KeychainProvider(), defaults: DefaultsProvider()),
                TestConfigurator()
               ]
    }()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        for configurator in configurators {
            configurator.configure()
        }
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        let appSchemeName = "storiqaWallet://"
        
        let urlStr = url.absoluteString
        if urlStr.contains(Constants.NetworkAuth.kFacebookAppId) {
            return FBSDKApplicationDelegate.sharedInstance().application(app, open: url, options: options)
        } else if urlStr.contains(Constants.NetworkAuth.kGoogleClientId) {
            return GIDSignIn.sharedInstance().handle(url as URL?,
                                                     sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
                                                     annotation: options[UIApplicationOpenURLOptionsKey.annotation])
            
        } else if urlStr.hasPrefix(appSchemeName) {
            log.debug(urlStr)
            
            let token = String(urlStr.dropFirst(appSchemeName.count))
            
            if let window = self.window, let rootViewController = window.rootViewController {
                var currentController = rootViewController
                
                while let presentedController = currentController.presentedViewController {
                    currentController = presentedController
                }
                
                if let root = (currentController as? UINavigationController)?.viewControllers.last,
                    root is PasswordRecoveryConfirmViewController {
                    // PasswordRecoveryConfirmViewController is already opened
                    return true
                }
                
                PasswordRecoveryConfirmModule.create(token: token).present(from: currentController)
            }
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
}
