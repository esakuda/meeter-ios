//
//  AppDelegate.swift
//  Meeter
//
//  Created by Damian on 8/1/15.
//  Copyright © 2015 Meeter. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var parseService = ParseService()
    
    let applicationId = "lmbbIAwSCPFWLd53a5PONP4nDklAV2y9rNmpHqO5"
    let clientKey = "loAJ7tckzxG93PCSGeDZ7oZHHG0LVBfqOXK2B3Zm"

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        parseService.setAppData(applicationId, clientKey: clientKey)
        parseService.registerAppForPushNotifications(application, launchOptions: launchOptions)
        
        return true
    }

    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        parseService.storeDeviceToken(deviceToken)
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        parseService.failedInstallingNotification(error)
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        parseService.handleNotificaciont(application, userInfo: userInfo)
    }

}

