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
    
    var userRetweet = false
    var userFavorite = false
    
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
        
        var tapTweetRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.tappedRetweetImage(_:)))
        self.retweetButton.addGestureRecognizer(tapTweetRecognizer)
        self.retweetButton.isUserInteractionEnabled = true
        
        var tapFavoriteRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.tappedFavoriteImage(_:)))
        self.favoriteButton.addGestureRecognizer(tapFavoriteRecognizer)
        self.favoriteButton.isUserInteractionEnabled = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func tappedRetweetImage(_ sender: Any) {
        if(userRetweet) {
            retweetButton.image = UIImage(named: "retweet-icon")
            retweetCountLabel.text = "\(tweet.retweetCount)"
            userRetweet = false
        } else {
            retweetButton.image = UIImage(named: "retweet-icon-green")
            
            TwitterClient.sharedInstance?.retweet(id: tweet.id!, success: { (tweet) in
                
            }, failure: { (error: Error) in
                print(error.localizedDescription)
            })
            
            retweetCountLabel.text = "\((tweet.retweetCount)+1)"
            userRetweet = true
        }
    }
    
    func tappedFavoriteImage(_ sender: Any) {
        if(userFavorite) {
            favoriteButton.image = UIImage(named: "fav-icon")
            favoriteCountLabel.text = "\(tweet.favoriteCount)"
            userFavorite = false
        } else {
            favoriteButton.image = UIImage(named: "favor-icon-red")
            
            TwitterClient.sharedInstance?.favorited(id: tweet.id!, success: {
                
            }, failure: { (error: Error) in
                print(error.localizedDescription)
            })
            
            favoriteCountLabel.text = "\((tweet.favoriteCount)+1)"
            userFavorite = true
        }
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
