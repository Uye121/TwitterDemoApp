//
//  ProfileViewController.swift
//  TwitterDemo
//
//  Created by Ulric Ye on 3/4/17.
//  Copyright © 2017 uye. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var tweetCountLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var followersCountLabel: UILabel!
    
    var user: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        TwitterClient.sharedInstance?.currentAccount(success: { (user) in
            //self.backgroundImage.setImageWith(user.profileBackgroundURL!)
            self.profileImage.setImageWith(user.profileURL!)
            self.userNameLabel.text = user.name
            self.screenNameLabel.text = user.screenName
            
            self.tweetCountLabel.text = "\(user.tweetCount!)"
            self.followingCountLabel.text = "\(user.followerCount!)"
            self.followersCountLabel.text = "\(user.followingCount!)"
            //self.backgroundImage.setImageWith(user.profileBackgroundURL!)
        }, failure: { (error: Error) in
            print(error.localizedDescription)
        })

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dismissView(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
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
