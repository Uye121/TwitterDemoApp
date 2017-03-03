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

    var tweet: Tweet?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        userNameLabel.text = tweet?.user?.name
        screenNameLabel.text = tweet?.user?.screenName
        descriptionLabel.text = tweet?.user?.tagline
        timeLabel.text = tweet?.timeString
        retweetCountLabel.text = "\(tweet?.retweetCount)"
        favoriteCountLabel.text = "\(tweet?.favoriteCount)"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
