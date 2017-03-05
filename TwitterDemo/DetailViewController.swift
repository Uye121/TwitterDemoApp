//
//  DetailViewController.swift
//  TwitterDemo
//
//  Created by Ulric Ye on 3/1/17.
//  Copyright © 2017 uye. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var favoriteCountLabel: UILabel!    
    @IBOutlet weak var retweetButton: UIImageView!
    @IBOutlet weak var favoriteButton: UIImageView!
    
    var tweet: Tweet?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        profileImage.setImageWith((tweet?.user?.profileURL)!)
        userNameLabel.text = tweet?.user?.name
        screenNameLabel.text = tweet?.user?.screenName
        descriptionLabel.text = tweet?.user?.tagline
        timeLabel.text = tweet?.timeString
        if let screenName = tweet?.user?.screenName {
            screenNameLabel.text = "@\(screenName)"
        }
        if let tweetCount = tweet?.retweetCount {
            retweetCountLabel.text = "\(tweetCount)"
        }
        if let favCount = tweet?.favoriteCount {
            favoriteCountLabel.text = "\(favCount)"
        }
        
        var tapTweetRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.tappedRetweetImage(_:)))
        self.retweetButton.addGestureRecognizer(tapTweetRecognizer)
        self.retweetButton.isUserInteractionEnabled = true
        
        var tapFavoriteRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.tappedFavoriteImage(_:)))
        self.favoriteButton.addGestureRecognizer(tapFavoriteRecognizer)
        self.favoriteButton.isUserInteractionEnabled = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tappedRetweetImage(_ sender: Any) {
        if(tweet?.retweeted!)! {
            tweet?.retweetCount -= 1
            retweetButton.image = UIImage(named: "retweet-icon")

            if let retweetCount = tweet?.retweetCount {
                retweetCountLabel.text = "\(retweetCount)"
            }
            
            tweet?.retweeted = false
        } else {
            retweetButton.image = UIImage(named: "retweet-icon-green")
            
            TwitterClient.sharedInstance?.retweet(id: (tweet?.id!)!, success: { (tweet) in
                
            }, failure: { (error: Error) in
                print(error.localizedDescription)
            })
            
            tweet?.retweetCount += 1
            
            if let retweetCount = tweet?.retweetCount {
                retweetCountLabel.text = "\(retweetCount)"
            }

            tweet?.retweeted = true
        }
    }
    
    func tappedFavoriteImage(_ sender: Any) {
        if(tweet?.favorited!)! {
            tweet?.favoriteCount -= 1
            favoriteButton.image = UIImage(named: "favor-icon")
            
            if let retweetCount = tweet?.retweetCount {
                retweetCountLabel.text = "\(retweetCount)"
            }
            
            tweet?.favorited = false
        } else {
            favoriteButton.image = UIImage(named: "favor-icon-red")
            
            TwitterClient.sharedInstance?.favorited(id: (tweet?.id!)!, success: {
                
            }, failure: { (error: Error) in
                print(error.localizedDescription)
            })
            
            tweet?.favoriteCount += 1
            
            if let favoriteCount = tweet?.favoriteCount {
                favoriteCountLabel.text = "\(favoriteCount)"
            }

            tweet?.favorited = true
        }
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
