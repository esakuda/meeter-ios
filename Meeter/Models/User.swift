//
//  UserModel.swift
//  Meeter
//
//  Created by Francisco Depascuali on 8/1/15.
//  Copyright © 2015 Meeter. All rights reserved.
//

import Foundation

class User {
    var userID : String
    var userName : String
    var profileImageUrl : String
    
    init(userID : String, userName : String, profileImageUrl : String){
        self.userID = userID
        self.userName = userName
        self.profileImageUrl = profileImageUrl
    }
}
