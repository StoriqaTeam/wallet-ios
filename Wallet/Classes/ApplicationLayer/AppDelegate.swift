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
        
//        let authToken = "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJ1c2VyX2lkIjo4OCwiZXhwIjoxNTQxODU3NzQ5LCJwcm92aWRlciI6IkVtYWlsIn0.dyn2XrTv2mnWE_JsgkKGYrDkiu_caA_W8fWZZNuDTNewOgOhTRZlrlH9fBKVs5T-neemv-RTj3iKWY7mkACV4RrjN7aIIpquRcu3rr0wgHmRch24pKDIulP5eoGl-JIcAwVrGlyM6M0zSwNB830__ZGqO8fuffw-7aUdRK14Q_fxAwUtjAJsnhL7Y6tUzp1EYVCdiBoWDmu1RTM441Hpb4rPAhQ7zp0dhCkWFcl6Aco95Jb-(1PkDQeHnMEBuGWD-syDU9S_aZ5e0_khc2kf0xQkULbVvMfm4y9woG6baibsyKsL1xi90yXISyNXDwC9mrsq0A36TZ1l0s0oephOI3Q"
//        
//        let exchangRateService = ExchangeRateNetworkProvider()
//        exchangRateService.getExchangeRate(authToken: authToken,
//                                           from: .btc,
//                                           to: .eth,
//                                           amountCurrency: .btc,
//                                           amountInMinUnits: 100000000,
//                                           queue: .main) { (result) in
//                                            switch result {
//                                            case .success(let exchangeRate):
//                                                print(exchangeRate)
//                                            case .failure(let error):
//                                                print(error)
//                                            }
//        }
        
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
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        guard let link = UniversalLinkParser().parse(link: userActivity.webpageURL) else {
            return false
        }
        
        switch link {
        case .verifyEmail(let token):
            EmailConfirmModule.create(app: app, token: token).present()
        case .resetPassword(let token):
            PasswordRecoveryConfirmModule.create(app: app, token: token).present()
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
