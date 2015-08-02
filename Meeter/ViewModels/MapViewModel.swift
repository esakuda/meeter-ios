//
//  MapViewModel.swift
//  Meeter
//
//  Created by Damian on 8/1/15.
//  Copyright © 2015 Meeter. All rights reserved.
//

import Foundation
import GoogleMaps

class MapViewModel: NSObject, CLLocationManagerDelegate {
    
    var locationAuthorizationManager : CLLocationManager = CLLocationManager()
    var markers : [MarkerViewModel] = []
    var firstLocationUpdate : Bool = true
    var mapBoundsDelegate : MapBoundsDelegate? = nil
    var timer : NSTimer? = nil
    
    
    let firstLocationNotification = "didChangeLocation"
    let noAuthorizationNotification = "noAuthNotification"
    let didUpdateUserLocations = "didUpdateUserLocations"
    let nearFriends = "new_near_friend"
    let mapRepository = MapRepository();
    
    let timeInterval : UInt64 = 10
    
    override init() {
        super.init()
        self.locationAuthorizationManager.delegate = self
    }
    
    // MARK - CLLocationManagerDelegate
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        if self.firstLocationUpdate {
            let info = [ "location":location! ]
            print(location)
            NSNotificationCenter.defaultCenter().postNotificationName(firstLocationNotification, object: nil, userInfo: info)
            self.firstLocationUpdate = false
        }
        self.sendLocation(location)
        
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if(status != CLAuthorizationStatus.AuthorizedWhenInUse && status != CLAuthorizationStatus.AuthorizedAlways) {
            let info = [ "message": NSLocalizedString("no_map_auth", comment:"") ]
            NSNotificationCenter.defaultCenter().postNotificationName(noAuthorizationNotification, object: nil, userInfo: info)
        }
    }
    
    // MARK - Request methods
    
    func sendLocation(location: CLLocation?) {
        if location != nil && self.mapBoundsDelegate != nil {
            let southWest = self.mapBoundsDelegate!.getSouthWest()
            let northEast = self.mapBoundsDelegate!.getNorthEast()
            self.mapRepository.sendLocation(location!, southWest:southWest, northEast: northEast, success:nil, failure: nil)
        }
    }
    
    // MARK - Enable Location methods
    
    func enableMyLocation(success: (() -> ())?, failure: (() -> ())?) {
        let status : CLAuthorizationStatus = CLLocationManager.authorizationStatus()
        
        if (status == CLAuthorizationStatus.NotDetermined) {
            self.requestLocationAuthorization();
            self.startUpdating();
            if let successClosure = success {
                successClosure()
            }
        } else if (status != CLAuthorizationStatus.Denied && status != CLAuthorizationStatus.Restricted) {
            self.requestLocationAuthorization();
            self.startUpdating();
            if let successClosure = success {
                successClosure()
            }
        }
        if let failureClosure = failure {
            failureClosure()
        }
    }
    
    func requestLocationAuthorization() {
        if(self.locationAuthorizationManager.respondsToSelector("requestWhenInUseAuthorization")) {
            self.locationAuthorizationManager.requestWhenInUseAuthorization();
        }
        if(self.locationAuthorizationManager.respondsToSelector("requestAlwaysAuthorization")) {
            self.locationAuthorizationManager.requestAlwaysAuthorization();
        }
        self.locationAuthorizationManager.startUpdatingLocation();
    }
    
    func startUpdating() {
        if(self.timer != nil) {
            dispatch_async(dispatch_get_main_queue(), {
                self.timer!.invalidate()
            })
        }
        dispatch_async(dispatch_get_main_queue(), {
            self.timer = NSTimer.scheduledTimerWithTimeInterval(10.0, target: self, selector: Selector("forceUpdateLocation"), userInfo: nil, repeats: true)
        })
    }
    
    func forceUpdateLocation() {
        self.locationAuthorizationManager.stopUpdatingLocation()
        self.locationAuthorizationManager.startUpdatingLocation()
    }
    
    func stopUpdating() {
        dispatch_async(dispatch_get_main_queue(), {
            self.timer!.invalidate()
        })
    }
    
}
