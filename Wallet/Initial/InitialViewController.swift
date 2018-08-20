//
//  InitialViewController.swift
//  Wallet
//
//  Created by user on 15.08.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation
import UIKit

class InitialViewController: UIViewController {
    
    @IBOutlet private var loginButton: StqButton?
    @IBOutlet private var signUpButton: StqButton? {
        didSet {
            signUpButton?.setTransparentButton()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func login(_ sender: Any) {
        
    }
    
    @IBAction func signUp(_ sender: Any) {
        
    }
    
    
    
}
