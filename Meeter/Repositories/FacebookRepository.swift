
//  FacebookRepository.swift
//  Meeter
//
//  Created by Francisco Depascuali on 8/1/15.
//  Copyright © 2015 Meeter. All rights reserved.
//

import Foundation

class FacebookRepository {

    static let sharedInstance = FacebookRepository()

    func fetchUserData(errorHandler : (() -> ())?, success : User -> ()) {
        
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, picture"])
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            
            if ((errorHandler) != nil)
            {
                print("Error: \(error)")
            }
            else
            {
                let userName : String = result ["name"] as! String
                let profileImageUrl : String = result ["picture"]!["data"]!["url"] as! String
                let user : User = User(userName: userName, profileImageUrl: profileImageUrl)
                success(user)
            }
        })
    }
    
    func feedShareButton () -> FBSDKShareButton {
        let content : FBSDKShareLinkContent = FBSDKShareLinkContent()
        content.contentTitle = "Together"
        content.imageURL = NSURL(string: "https://pbs.twimg.com/profile_images/613867159031300096/AtretVAp.jpg")
        
        let button : FBSDKShareButton = FBSDKShareButton()
        button.shareContent = content
        button.frame = CGRectMake((UIScreen.mainScreen().bounds.width - 100) * 0.5, 100, 80, 25)
        return button
    }
}
