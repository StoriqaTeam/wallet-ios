//
//  AppDelegate.swift
//  Wallet
//
//  Created by user on 15.08.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit
import AlamofireNetworkActivityIndicator

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
        return true
    }


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        //The network activity indicator will show and hide automatically as Alamofire requests start and complete.
        NetworkActivityIndicatorManager.shared.isEnabled = true
        
        // Override point for customization after application launch.
        setDefaultApperance()
        setInitialVC()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
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


}

private extension AppDelegate {
    func setDefaultApperance() {
        
        // UINavigationBar settings
        let appearance = UINavigationBar.appearance()
        //        let backButtonImage = #imageLiteral(resourceName: "backArrow")
        //        appearance.backIndicatorImage = backButtonImage
        //        appearance.backIndicatorTransitionMaskImage = backButtonImage
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
        
        let initialViewController: UIViewController
        
        if isFirstLaunch {
            isFirstLaunch = false
            initialViewController = Storyboard.main.viewController(identifier: "FirstLaunchVC")
        } else if pinIsSet {
            initialViewController = Storyboard.main.viewController(identifier: "PinLoginVC")
        } else {
            //            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            //            initialViewController = storyboard.instantiateViewController(withIdentifier: "LoginVC")
            initialViewController = Storyboard.main.viewController(identifier: "LoginVC")
        }
        
        self.window?.rootViewController = initialViewController //UINavigationController(rootViewController: initialViewController)
        self.window?.makeKeyAndVisible()
    }
}

