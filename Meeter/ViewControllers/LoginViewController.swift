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
    let mapSegue = "mapSegue"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerForNotifications()
        if (FBSDKAccessToken.currentAccessToken() != nil) {
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let userId : NSNumber = NSUserDefaults.standardUserDefaults().objectForKey("user")! as! NSNumber
            appDelegate.setUserToParse(userId)
            self.performSegueWithIdentifier(mapSegue, sender: self)
        }
        else {
            facebookLoginButton.readPermissions = loginViewModel.facebookPermissions
            facebookLoginButton.delegate = self.loginViewModel
        }
        self.navigationController?.navigationBar.hidden = true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let segueIdentifier = segue.identifier
        if segueIdentifier == mapSegue {
            let viewController = segue.destinationViewController as! MapViewController
            viewController.userViewModel = self.loginViewModel.userViewModel()
        }
    }
    
    func registerForNotifications() {
        NSNotificationCenter.defaultCenter().addObserverForName(self.loginViewModel.didLoginNotification, object: nil, queue: NSOperationQueue.mainQueue(), usingBlock: { notification in
            self.performSegueWithIdentifier(self.mapSegue, sender: self)
        })
    }
}
