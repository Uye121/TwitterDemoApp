//
//  Tweet.swift
//  TwitterDemo
//
//  Created by Ulric Ye on 2/27/17.
//  Copyright © 2017 uye. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    
    var user: User?
    var text: String?
    var timeStamp: Date?
    var timeString: String?
    var retweetCount: Int = 0
    var favoriteCount: Int = 0
    var id: Int?
    
    init(dictionary: NSDictionary) {
        user = User(dictionary: (dictionary["user"] as? NSDictionary)!)
        text = dictionary["text"] as? String
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        favoriteCount = (dictionary["favorite_count"] as? Int) ?? 0
        id = (dictionary["id"] as? Int) ?? 0
        
        let timeStampString = dictionary["created_at"] as? String
        
        if let timeStampString = timeStampString {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            timeStamp = formatter.date(from: timeStampString)
            formatter.dateStyle = .short
            formatter.timeStyle = .short
            timeString = formatter.string(from: timeStamp!)
        }
    }
    
    class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        
        for dictionary in dictionaries {
            let tweet = Tweet(dictionary: dictionary)
            
            tweets.append(tweet)
        }
        return tweets
    }

}
