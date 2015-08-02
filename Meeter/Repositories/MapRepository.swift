//
//  MapRepository.swift
//  Meeter
//
//  Created by Damian on 8/1/15.
//  Copyright © 2015 Meeter. All rights reserved.
//

import CoreLocation
import Foundation

class MapRepository : Repository {
    
    func sendLocation(location: CLLocation, southWest: CLLocationCoordinate2D, northEast: CLLocationCoordinate2D, success: (() -> ())?, failure: ((NSError) -> ())?) {
        let parameters = [  "token":FBSDKAccessToken.currentAccessToken().tokenString,
                            "latitude":location.coordinate.latitude,
                            "longitude":location.coordinate.longitude,
                            "longitude_min":northEast.longitude,
                            "latitude_min":southWest.latitude,
                            "longitude_max":southWest.longitude,
                            "latitude_max":northEast.latitude]
        let url = "\(self.url)/users/update_position"
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.POST(url, parameters: parameters, success: { operation, responseObject in
            let asd : AFHTTPRequestOperation = operation
            print(asd.response.statusCode)
            if let successClosure = success {
                successClosure()
            }
        }, failure: { operation, error in
            if let failureClosure = failure {
                failureClosure(error)
            }
        })
    }
    
}
