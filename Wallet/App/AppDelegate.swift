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
    
    private var isFirstLaunch: Bool {
        set {
            UserDefaults.standard.set(isFirstLaunch, forKey: Constants.Keys.kIsFirstLaunch)
        }
        get {
            if let _ = UserDefaults.standard.object(forKey: Constants.Keys.kIsFirstLaunch) {
                //not a firstLaunch if key has any value
                return false
            } else {
                return true
            }
        }
    }
    
    private var pinIsSet: Bool {
        //TODO: проверка, установлен ли пин
        return false
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        //The network activity indicator will show and hide automatically as Alamofire requests start and complete.
        NetworkActivityIndicatorManager.shared.isEnabled = true
        
        // Override point for customization after application launch.
        setDefaultApperance()
        setInitialVC()
        
        // Google initialize sign-in
        GIDSignIn.sharedInstance().clientID = googleClientId
        GIDSignIn.sharedInstance().delegate = self
        
        //        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        
        //TODO: нужно ли
        //        FBSDKAppEvents.activateApp()
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        let appSchemeName = "storiqaWallet://"
        
        let urlStr = url.absoluteString
        if urlStr.contains(facebookAppId) {
            return FBSDKApplicationDelegate.sharedInstance().application(app, open: url, options: options)
        } else if urlStr.contains(googleClientId) {
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
                if let controller = PasswordRecoveryConfirmViewController.create(token: token) {
                    currentController.present(controller, animated: true, completion: nil)
                }
            }
        }
        return true
    }
    
    
    func application(_ application: UIApplication,
                     open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return GIDSignIn.sharedInstance().handle(url,
                                                 sourceApplication: sourceApplication,
                                                 annotation: annotation)
    }
}

private extension AppDelegate {
    func setDefaultApperance() {
        
        // UINavigationBar settings
        let appearance = UINavigationBar.appearance()
        let backButtonImage = #imageLiteral(resourceName: "backArrow")
        appearance.backIndicatorImage = backButtonImage
        appearance.backIndicatorTransitionMaskImage = backButtonImage
        appearance.tintColor = UIColor.darkGray
        //
        //        appearance.titleTextAttributes = [.font: UIFont.boldSystemFont(ofSize: 24)]
        appearance.setBackgroundImage(UIImage(), for: .default)
        appearance.shadowImage = UIImage()
        appearance.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
        //        appearance.isTranslucent = true
    }
    
    func setInitialVC() {
        // setting initial vc on storyboard and then resetting it programmatically causes memory leak
        // othervise we get warning
        // "Failed to instantiate the default view controller for UIMainStoryboardFile 'Main' - perhaps the designated entry point is not set?"
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        let initialViewController: UIViewController?
        
        if isFirstLaunch {
            isFirstLaunch = false
            initialViewController = Storyboard.main.viewController(identifier: "FirstLaunchVC", fatal: true)
        } else if pinIsSet {
            initialViewController = Storyboard.main.viewController(identifier: "PinLoginVC")
        } else {
            //            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            //            initialViewController = storyboard.instantiateViewController(withIdentifier: "LoginVC")
            initialViewController = Storyboard.main.viewController(identifier: "LoginVC")
        }
        
        if let initialViewController = initialViewController {
            self.window?.rootViewController = UINavigationController(rootViewController: initialViewController)
            self.window?.makeKeyAndVisible()
        } else {
            log.error("initialViewController is nil")
        }
    }
}

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
