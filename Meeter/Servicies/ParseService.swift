//
//  ParseService.swift
//  Meeter
//
//  Created by María Eugenia Sakuda on 8/1/15.
//  Copyright © 2015 Meeter. All rights reserved.
//

import Foundation

class ParseService {
    
    func setAppData(applicationId: String, clientKey: String) {
        Parse.setApplicationId(applicationId, clientKey: clientKey)
    }
    
    func registerAppForPushNotifications(application: UIApplication, launchOptions: [NSObject: AnyObject]?) {
        if application.applicationState != UIApplicationState.Background {
            let preBackgroundPush = !application.respondsToSelector("backgroundRefreshStatus")
            let oldPushHandlerOnly = !AppDelegate.respondsToSelector("application:didReceiveRemoteNotification:fetchCompletionHandler:")
            var pushPayload = false
            if let options = launchOptions {
                pushPayload = options[UIApplicationLaunchOptionsRemoteNotificationKey] != nil
            }
            if (preBackgroundPush || oldPushHandlerOnly || pushPayload) {
                PFAnalytics.trackAppOpenedWithLaunchOptionsInBackground(launchOptions, block: nil)
            }
        }
        if application.respondsToSelector("registerUserNotificationSettings:") {
            let settings = UIUserNotificationSettings(forTypes: [.Alert, .Badge], categories: nil)
            UIApplication.sharedApplication().registerUserNotificationSettings(settings)
            
            application.registerUserNotificationSettings(settings)
            application.registerForRemoteNotifications()
        } else {
            application.registerForRemoteNotifications()
        }
    }
    
    func storeDeviceToken(deviceToken: NSData) {
        let installation = PFInstallation.currentInstallation()
        installation.setDeviceTokenFromData(deviceToken)
        installation.saveInBackground()
    }
    
    func failedInstallingNotification(error: NSError) {
        if error.code == 3010 {
            print("Push notifications are not supported in the iOS Simulator.")
        } else {
            print("application:didFailToRegisterForRemoteNotificationsWithError: %@", error)
        }
    }
    
    func handleNotificaciont(application: UIApplication, userInfo: [NSObject : AnyObject]) {
        PFPush.handlePush(userInfo)
        if application.applicationState == UIApplicationState.Inactive {
            PFAnalytics.trackAppOpenedWithRemoteNotificationPayload(userInfo)
        }
    }
}