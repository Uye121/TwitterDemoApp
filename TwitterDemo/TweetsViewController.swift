//
//  TweetsViewController.swift
//  TwitterDemo
//
//  Created by Ulric Ye on 2/27/17.
//  Copyright © 2017 uye. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tweets: [Tweet]!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        
        TwitterClient.sharedInstance?.homeTimeLine(success: { (tweets: [Tweet]) in
            self.tweets = tweets
            
            
            self.tableView.reloadData()
        }, failure: { (error) in
            print(error.localizedDescription)
        })
        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        TwitterClient.sharedInstance?.homeTimeLine(success: { (tweets: [Tweet]) in
            
            self.tableView.reloadData()
        }, failure: { (error) in
            print(error.localizedDescription)
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLogoutButton(_ sender: Any) {
        TwitterClient.sharedInstance?.logout()
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
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if let sender = sender as? UITableViewCell {
            let indexPath = tableView.indexPath(for: sender)
            let tweet = self.tweets[(indexPath?.row)!]
            
            let detailViewController = segue.destination as! DetailViewController
            detailViewController.tweet = tweet
        }
        
        if let sender = sender as? UIBarButtonItem {
            if(sender.title == "Profile") {
                let profileViewController = segue.destination as! ProfileViewController
                profileViewController.user = User._currentUser
            } else {
                print("success")
                let replyViewController = segue.destination as! ReplyViewController
                replyViewController.user = User._currentUser
            }
        }
        
        if let sender = sender as? UIButton {
            if let cell = sender.superview?.superview as? TweetCell {
                let indexPath = tableView.indexPath(for: cell)
                let tweet = tweets[(indexPath?.row)!]
                
                let otherProfileViewController = segue.destination as! OtherProfileViewController
                otherProfileViewController.user = tweet.user
            }
        }
    }
    
    
}
