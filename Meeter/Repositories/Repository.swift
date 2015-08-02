//
//  Repository.swift
//  Meeter
//
//  Created by Damian on 8/1/15.
//  Copyright © 2015 Meeter. All rights reserved.
//

import Foundation

class Repository {
    
    let url = "http://192.168.1.31:3000"
    let manager = AFHTTPRequestOperationManager()
    
    init() {
        self.manager.requestSerializer.setValue("application/json", forHTTPHeaderField: "Content-Type")
    }
    
}