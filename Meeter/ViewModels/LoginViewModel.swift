//
//  LoginViewModel.swift
//  Meeter
//
//  Created by Francisco Depascuali on 8/1/15.
//  Copyright © 2015 Meeter. All rights reserved.
//

class LoginViewModel: NSObject, FBSDKLoginButtonDelegate {
    
    let facebookRepository : FacebookRepository = FacebookRepository.sharedInstance
    let loginRepository : LoginRepository = LoginRepository.sharedInstance
    let facebookPermissions : [String] = ["public_profile", "email", "user_friends"]
    
    var user : User? = nil
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        print("User Logged In")
        
        if ((error) != nil)
        {
            // TODO: Process error
        }
        else if result.isCancelled {
            // TODO: Handle cancellations
        }
        else {
            NSUserDefaults.standardUserDefaults().setObject(FBSDKAccessToken.currentAccessToken().tokenString!, forKey: "session")
            loadUser()
        }
    }
    
    func loadUser() {
        facebookRepository.fetchUserData(nil, success:
            {user in self.user = user;
            self.loginRepository.sendUser(user, error: nil, success: nil)
        })
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("User Logged Out")
    }
}
