//
//  AppDelegate.swift
//  Meeter
//
//  Created by Damian on 8/1/15.
//  Copyright © 2015 Meeter. All rights reserved.
//

import UIKit
import GoogleMaps

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    let kGoogleMapsKey = "AIzaSyCzg8EHAQlfeNooXmR6jUkCmEqoFKMj4PA";
    var parseService = ParseService()
    
    let applicationId = "lmbbIAwSCPFWLd53a5PONP4nDklAV2y9rNmpHqO5"
    let clientKey = "loAJ7tckzxG93PCSGeDZ7oZHHG0LVBfqOXK2B3Zm"

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        parseService.setAppData(applicationId, clientKey: clientKey)
        parseService.registerAppForPushNotifications(application, launchOptions: launchOptions)
        GMSServices.provideAPIKey(kGoogleMapsKey);
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        parseService.storeDeviceToken(deviceToken)
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        parseService.failedInstallingNotification(error)
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        parseService.handleNotificacion(application, userInfo: userInfo)
    }
    
    func application(application: UIApplication,
        openURL url: NSURL,
        sourceApplication: String?,
        annotation: AnyObject) -> Bool {
            return FBSDKApplicationDelegate.sharedInstance().application(
                application,
                openURL: url,
                sourceApplication: sourceApplication,
                annotation: annotation)
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        FBSDKAppEvents.activateApp()

        parseService.handleBasicNotification()
    }
    
    func setUserToParse(userId: NSNumber) {
        parseService.setUser(userId)
    }
    
    func removeUserFromParse() {
        parseService.removeInstallation()
    }
}
