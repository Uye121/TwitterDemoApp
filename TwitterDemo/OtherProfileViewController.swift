//
//  OtherProfileViewController.swift
//  TwitterDemo
//
//  Created by Ulric Ye on 3/5/17.
//  Copyright © 2017 uye. All rights reserved.
//

import UIKit

class OtherProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var tweetCountLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var followersCountLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var user: User!
    var tweets: [Tweet]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        
        // Do any additional setup after loading the view.
        self.profileImage.setImageWith(user.profileURL!)
        self.userNameLabel.text = user.name
        self.screenNameLabel.text = user.screenName
        self.tweetCountLabel.text = convertNumber(people: user.tweetCount!)
        self.followingCountLabel.text = convertNumber(people: user.followingCount!)
        self.followersCountLabel.text = convertNumber(people: user.followerCount!)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        TwitterClient.sharedInstance?.userTimeline(id: user.userID!, success: { (tweets:[Tweet]) in
            self.tweets = tweets
            self.tableView.reloadData()
        }, failure: { (error: Error) in
            print(error.localizedDescription)
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func convertNumber(people: Int) -> String {
        var numberOfPeople: String?
        var oneMillion = 1000000
        var oneThousand = 1000
        if(people >= oneMillion) {
            numberOfPeople = "\(people/oneMillion)M"
        } else if(people >= oneThousand) {
            numberOfPeople = "\(people/oneThousand)K"
        } else {
            numberOfPeople = "\(people)"
        }
        
        return numberOfPeople!
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tweets?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetCell
        
        cell.tweet = tweets[indexPath.row]
        cell.selectionStyle = .none
        
        return cell
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
