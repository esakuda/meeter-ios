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

    var i = 0 // ERASE
    
    func sendLocation(location: CLLocation, southWest: CLLocationCoordinate2D, northEast: CLLocationCoordinate2D, success: (() -> ())?, failure: ((NSError) -> ())?) {
        let token = "asd"
        
        let parameters = [  "token":token,
                            "latitude":location.coordinate.latitude,
                            "longitude":location.coordinate.longitude,
                            "longitude_min":northEast.longitude,
                            "latitude_min":southWest.latitude,
                            "longitude_max":southWest.longitude,
                            "latitude_max":northEast.latitude,
                            "token":token]
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
        
        
//        self.i++
//        print(self.i)
//        if(self.i % 2 == 0) {
//            success!([User(params: ["latitude":-34.581066, "longitude":-58.421874, "name":"Charly", "id": 1])])
//        } else {
//            success!([User(params: ["latitude":-34.577922, "longitude":-58.426852, "name":"Juancito", "id": 1])])
//        }
    }
    
}
