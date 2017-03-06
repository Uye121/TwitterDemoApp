//
//  TweetCell.swift
//  TwitterDemo
//
//  Created by Ulric Ye on 2/27/17.
//  Copyright © 2017 uye. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var retweetButton: UIImageView!
    @IBOutlet weak var retweetCountLabel: UILabel!
    
    @IBOutlet weak var favoriteButton: UIImageView!
    @IBOutlet weak var favoriteCountLabel: UILabel!
    
    var tweet: Tweet! {
        didSet {
            userNameLabel.text = tweet.user?.name
            if let userTag = tweet.user?.screenName {
                screenNameLabel.text = "@\(userTag)"
            }
            descriptionLabel.text = tweet.user?.tagline
            
            let timePast = Int(Date().timeIntervalSince(tweet.timeStamp!))
            let timeAgo = timeSince(time: timePast)
            timeLabel.text = timeAgo
            
            profileImage.setImageWith((tweet.user?.profileURL)!)
            
            if(tweet.retweetCount < 1000) {
                retweetCountLabel.text = "\(tweet.retweetCount)"
            } else {
                retweetCountLabel.text = "\(Double(tweet.retweetCount/1000))k"
            }
            
            if(tweet.favoriteCount < 1000) {
                favoriteCountLabel.text = "\(tweet.favoriteCount)"
            } else {
                favoriteCountLabel.text = "\(Double(tweet.favoriteCount))"
            }
        }
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let tapTweetRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.tappedRetweetImage(_:)))
        self.retweetButton.addGestureRecognizer(tapTweetRecognizer)
        self.retweetButton.isUserInteractionEnabled = true
        
        let tapFavoriteRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.tappedFavoriteImage(_:)))
        self.favoriteButton.addGestureRecognizer(tapFavoriteRecognizer)
        self.favoriteButton.isUserInteractionEnabled = true
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func tappedRetweetImage(_ sender: Any) {
        if(!((tweet?.retweeted!)!)) {
            TwitterClient.sharedInstance?.retweet(id: (tweet?.id!)!, success: { (response: Tweet) in
                self.retweetButton.image = UIImage(named: "retweet-icon-green")
                self.retweetCountLabel.text = "\(response.retweetCount)"
                self.tweet?.retweeted = true
            }, failure: { (error: Error) in
                print(error.localizedDescription)
            })
        } else {
            TwitterClient.sharedInstance?.unretweet(id: (tweet?.id!)!, success: { (response: Tweet) in
                self.retweetButton.image = UIImage(named: "retweet-icon")
                self.retweetCountLabel.text = "\(response.retweetCount)"
                self.tweet?.retweeted = false
            }, failure: { (error: Error) in
                print(error.localizedDescription)
            })
        }
    }
    
    func tappedFavoriteImage(_ sender: Any) {
        if(!(tweet?.favorited!)!) {
            TwitterClient.sharedInstance?.favorited(id: (tweet?.id!)!, success: { (response: Tweet) in
                self.favoriteButton.image = UIImage(named: "favor-icon-red")
                self.favoriteCountLabel.text = "\(response.favoriteCount)"
                self.tweet?.favorited = true
            }, failure: { (error: Error) in
                print(error.localizedDescription)
            })
        } else {
            TwitterClient.sharedInstance?.unfavorite(id: (tweet?.id!)!, success: { (response: Tweet) in
                self.favoriteButton.image = UIImage(named: "favor-icon")
                self.favoriteCountLabel.text = "\(response.favoriteCount)"
                self.tweet?.favorited = false
            }, failure: { (error: Error) in
                print(error.localizedDescription)
            })
        }
    }
    
    @IBAction func otherProfileTap(_ sender: Any) {
        print("Image tapped!")
    }
    
    func timeSince(time: Int) -> String {
        var timeString: String?
        
        if(time/60 < 60) {
            timeString = "\(time/60) m"
        } else if(time/3600 < 24) {
            timeString = "\(time/3600) h"
        } else {
            timeString = "\(time/86400) d"
        }
        
        return timeString!
    }
    
}
