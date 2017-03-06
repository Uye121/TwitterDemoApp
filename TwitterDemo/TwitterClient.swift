//
//  TwitterClient.swift
//  TwitterDemo
//
//  Created by Ulric Ye on 2/27/17.
//  Copyright © 2017 uye. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {
    
    static let sharedInstance = TwitterClient(baseURL: URL(string: "https://api.twitter.com"), consumerKey: "8ljIjdfnXUK7G7mCMWlLTqn86", consumerSecret: "ppdT7g49FyuR06qMC0ymikMD3v3Ve9ML9M6mO31GQL9lNALzVD")
    
    var loginSuccess: (() -> ())?
    var loginFailure: ((Error) -> ())?
    
    func login(success: @escaping () -> (), failure: @escaping (Error) -> ()) {
        loginSuccess = success
        loginFailure = failure
        
        TwitterClient.sharedInstance?.deauthorize()
        TwitterClient.sharedInstance?.fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: URL(string: "mytwitterdemo://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential?) -> Void in
            print("I got a token!")
            
            let url = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken!.token!)")
            UIApplication.shared.openURL(url!)
            
        }) { (error: Error?) -> Void in
            print("error: \(error!.localizedDescription)")
            self.loginFailure!(error!)
        }
    }
    
    func logout() {
        User.currentUser = nil
        deauthorize()
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: User.userDidlogoutNotification), object: nil)
    }
    
    func handleOpenURL(url: URL) {
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken, success: { (BDBOAuth1Credential) -> Void in
            print("I got the access token!")
            
            self.currentAccount(success: { (user: User) in
                User.currentUser = user
                self.loginSuccess?()
            }, failure: { (error) in
                self.loginFailure?(error)
            })
        }) { (error: Error?) -> Void in
            print("error: \(error!.localizedDescription)")
            self.loginFailure?(error!)
        }
    }
    
    func homeTimeLine(success: @escaping ([Tweet]) -> (), failure: @escaping (Error) -> ()) {
        
        get("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) -> Void in
            let dictionaries = response as! [NSDictionary]
            
            let tweets = Tweet.tweetsWithArray(dictionaries: dictionaries)
            
            success(tweets)
            
        }, failure: { (task: URLSessionDataTask?, error: Error) -> Void in
            failure(error)
        })
    }
    
    func currentAccount(success: @escaping (User) -> (), failure: @escaping (Error) -> ()) {
        get("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) -> Void in
            let userDictionary = response as! NSDictionary
            let user = User(dictionary: userDictionary)
            
            success(user)
        }, failure: { (task: URLSessionDataTask?, error: Error) -> Void in
            failure(error)
        })
    }
    
    func retweet(id: Int, success: @escaping (Tweet) -> (), failure: @escaping (Error) -> ())
    {
        
        post("1.1/statuses/retweet/\(id).json", parameters: nil, progress: nil, success: {(task: URLSessionDataTask, response: Any?) in
            let dictionary = response as! NSDictionary
            let tweet = Tweet.init(dictionary: dictionary)
            success(tweet)
        }) {(task: URLSessionDataTask?, error: Error) in
            failure(error)
            
        }
    }
    
    func unretweet(id: Int, success: @escaping (Tweet) -> (), failure: @escaping (Error) -> ())
    {
        post("1.1/statuses/unretweet/\(id).json", parameters: nil, progress: nil, success: {(task: URLSessionDataTask, response: Any?) in
            let dictionary = response as! NSDictionary
            let tweet = Tweet.init(dictionary: dictionary)
            success(tweet)
        }) {(task: URLSessionDataTask?, error: Error) in
            failure(error)
        }
    }
    
    func favorited(id: Int, success: @escaping (Tweet) -> (), failure: @escaping (Error) -> ())
    {
        
        post("1.1/favorites/create.json?id=\(id)", parameters: nil, progress: nil, success: {(task: URLSessionDataTask, response: Any?) in
            let dictionary = response as! NSDictionary
            let tweet = Tweet.init(dictionary: dictionary)
            success(tweet)
        }) {(task: URLSessionDataTask?, error: Error) in
            failure(error)
            
        }
    }
    
    func unfavorite(id: Int, success: @escaping (Tweet) -> (), failure: @escaping (Error) -> ())
    {
        post("1.1/favorites/destroy.json", parameters: ["id": id], progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            let dictionary = response as! NSDictionary
            let tweet = Tweet.init(dictionary: dictionary)
            success(tweet)
            
        }) { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        }
    }
}
