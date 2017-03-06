//
//  User.swift
//  TwitterDemo
//
//  Created by Ulric Ye on 2/27/17.
//  Copyright © 2017 uye. All rights reserved.
//

import UIKit

class User: NSObject {
    
    var name: String?
    var screenName: String?
    var profileURL: URL?
    var profileBackgroundURL: URL?
    var tagline: String?
    var tweetCount: Int?
    var followerCount: Int?
    var followingCount: Int?
    var userID: Int?
    
    var dictionary: NSDictionary?
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        
        name = dictionary["name"] as? String
        screenName = dictionary["screen_name"] as? String
        tweetCount = (dictionary["statuses_count"] as? Int) ?? 0
        followerCount = (dictionary["friends_count"] as? Int) ?? 0
        followingCount = (dictionary["followers_count"] as? Int) ?? 0
        userID = dictionary["id"] as? Int
        
        let profileURLString = dictionary["profile_image_url_https"] as? String
        if let profileURLString = profileURLString {
            profileURL = URL(string: profileURLString)
        }
        
        let backgroundURLString = dictionary["profile_background_image_url_https"] as? String
        if let backgroundURLString = backgroundURLString {
            profileBackgroundURL = URL(string: backgroundURLString)
        }
        
        tagline = dictionary["description"] as? String
    }
    
    static var _currentUser: User?
    static let userDidlogoutNotification =  "userDidLougout"

    
    class var currentUser: User? {
        get {
            if _currentUser == nil {
                let defaults = UserDefaults.standard
                
                let userData = defaults.object(forKey: "currentUserData") as? Data
                
                if let userData = userData {
                    let dictionary = try! JSONSerialization.jsonObject(with: userData, options: []) as! NSDictionary
                    _currentUser = User(dictionary: dictionary)
                }
            }
            return _currentUser
        }
        
        set(user) {
            _currentUser = user
            
            let defaults = UserDefaults.standard
            
            if let user = user {
                let data = try! JSONSerialization.data(withJSONObject: user.dictionary!, options: [])
                
                defaults.set(data, forKey: "currentUserData")
            } else {
                defaults.set(nil, forKey: "currentUserData")
            }
            
            defaults.synchronize()
        }
    }
}
