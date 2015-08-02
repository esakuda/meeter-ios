//
//  LoginRepository.swift
//  Meeter
//
//  Created by Francisco Depascuali on 8/1/15.
//  Copyright © 2015 Meeter. All rights reserved.
//

import Foundation

class LoginRepository {
    
    static let sharedInstance = LoginRepository()
    
    let manager = AFHTTPRequestOperationManager();
    let url = "http://192.168.1.31:3000"

    func sendUser(user: User, error: (() -> ())?, success: (() -> ())?) {
        let parameters = ["name": user.name, "token": NSUserDefaults.standardUserDefaults().stringForKey("session")!]
        let url = "\(self.url)/users/login"
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.POST(url, parameters: parameters, success: { operation, responseObject in
            if let successClosure = success {
                print("request mandada correctamente")
                successClosure()
            }
            }, failure: { operation, error in
                print("ha ocurrido un error")
        })
    }
}

