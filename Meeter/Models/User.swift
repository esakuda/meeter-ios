//
//  User.swift
//  Meeter
//
//  Created by Damian on 8/1/15.
//  Copyright © 2015 Meeter. All rights reserved.
//

import UIKit

class User {

    var latitude : Double?
    var longitude : Double?
    var name : String
    var id : Int?
    var profileImageUrl : String?
    
    init(params: Dictionary<String,AnyObject>) {
        self.latitude = params["latitude"] as? Double
        self.longitude = params["longitude"] as? Double
        self.name = params["name"] as! String
        self.id = params["id"] as? Int
    }
    
    init(userName : String, profileImageUrl : String){
        self.name = userName
        self.profileImageUrl = profileImageUrl
        self.id = nil
    }
    
    class func usersFromJSON(params: Array<Dictionary<String, AnyObject>>) -> Array<User> {
        return params.map({ dictionary in User(params: dictionary) })
    }
    
}
