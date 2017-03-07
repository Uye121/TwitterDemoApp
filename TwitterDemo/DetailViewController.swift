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
    
    @IBOutlet weak var retweetDisplayPic: UIImageView!
    @IBOutlet weak var retweetDisplayLabel: UILabel!
    
    var tweet: Tweet?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        profileImage.setImageWith((tweet?.user?.profileURL)!)
        userNameLabel.text = tweet?.user?.name
        screenNameLabel.text = tweet?.user?.screenName
        descriptionLabel.text = tweet?.text
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
        
        if(tweet?.retweeted)! {
            retweetDisplayPic.isHidden = true
            retweetDisplayLabel.isHidden = true
        } else {
            retweetDisplayPic.isHidden = true
            retweetDisplayLabel.isHidden = true
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
        if(!((tweet?.retweeted!)!)) {
            TwitterClient.sharedInstance?.retweet(id: (tweet?.id!)!, success: { (response: Tweet) in
                self.retweetButton.image = UIImage(named: "retweet-icon-green")
                self.retweetCountLabel.text = "\(response.retweetCount)"
                self.tweet?.retweeted = true
                self.retweetDisplayPic.isHidden = false
                self.retweetDisplayLabel.isHidden = false
            }, failure: { (error: Error) in
                print(error.localizedDescription)
            })
        } else {
            TwitterClient.sharedInstance?.unretweet(id: (tweet?.id!)!, success: { (response: Tweet) in
                self.retweetButton.image = UIImage(named: "retweet-icon")
                self.retweetCountLabel.text = "\(response.retweetCount)"
                self.tweet?.retweeted = false
                self.retweetDisplayPic.isHidden = true
                self.retweetDisplayLabel.isHidden = true
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
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
