//
//  LoginViewController.swift
//  Meeter
//
//  Created by Francisco Depascuali on 8/1/15.
//  Copyright © 2015 Meeter. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var facebookLoginButton: FBSDKLoginButton!
    
    let loginViewModel : LoginViewModel = LoginViewModel.new()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (FBSDKAccessToken.currentAccessToken() != nil) {
            //pushear proxima vista
        }
        else {
            facebookLoginButton.readPermissions = loginViewModel.facebookPermissions
            facebookLoginButton.delegate = self.loginViewModel
        }
    }
}
