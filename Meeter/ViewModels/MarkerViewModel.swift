//
//  MarkerViewModel.swift
//  Meeter
//
//  Created by Damian on 8/1/15.
//  Copyright © 2015 Meeter. All rights reserved.
//

import Foundation
import GoogleMaps

class MarkerViewModel {
    
    var marker : GMSMarker
    var user : User
    var publicity : String
    
    init (marker: GMSMarker, user: User, publicity: String) {
        self.marker = marker
        self.user = user;
        self.publicity = publicity;
    }
    
    class func mapToMarkers(users:[User], publicity: String) -> [MarkerViewModel] {
        return users.filter{ user in return user.latitude != nil && user.longitude != nil }.map({ user -> MarkerViewModel in
            let marker = GMSMarker();
            marker.position = CLLocationCoordinate2D(latitude: user.latitude!, longitude: user.longitude!)
            marker.icon = UIImage(named:"Layer-1")
            marker.appearAnimation = kGMSMarkerAnimationPop
            return MarkerViewModel(marker: marker, user: user, publicity: publicity)
        })
    }
    
}