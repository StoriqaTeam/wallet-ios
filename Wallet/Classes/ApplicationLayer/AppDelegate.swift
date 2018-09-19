//
//  AppDelegate.swift
//  Wallet
//
//  Created by user on 15.08.2018.
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
        return [ApplicationConfigurator(keychain: KeychainProvider(), defaults: DefaultsProvider())]
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
    
    //TODO: нужно ли
    func application(_ application: UIApplication,
                     open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return GIDSignIn.sharedInstance().handle(url,
                                                 sourceApplication: sourceApplication,
                                                 annotation: annotation)
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

//TODO: нужно ли
extension AppDelegate: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print("\(error.localizedDescription)")
        } else {
            // Perform any operations on signed in user here.
            let userId = user.userID                  // For client-side use only!
            let idToken = user.authentication.idToken // Safe to send to the server
            let fullName = user.profile.name
            let givenName = user.profile.givenName
            let familyName = user.profile.familyName
            let email = user.profile.email
            
            //TODO: sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!)
            
            print(userId,idToken,fullName,givenName,familyName,email)
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
        
        //TODO: sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!)
        // Perform any operations when the user disconnects from app here.
        // ...
    }
}
