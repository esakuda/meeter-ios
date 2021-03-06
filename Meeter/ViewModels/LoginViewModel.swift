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
    let didLoginNotification = "didLoginNotification"
    
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
            {user in self.user = user
                self.loginRepository.sendUser(user, error: nil, success: {
                    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                    appDelegate.setUserToParse(user.id!)
                    NSNotificationCenter.defaultCenter().postNotificationName(self.didLoginNotification, object: nil)
                })
        })
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.removeUserFromParse()
        print("User Logged Out")
    }
    
    func userViewModel() -> UserViewModel? {
        if user != nil {
            return UserViewModel(user: self.user!)
        } else {
            return nil
        }
    }
}
