//
//  ReplyViewController.swift
//  TwitterDemo
//
//  Created by Ulric Ye on 3/6/17.
//  Copyright © 2017 uye. All rights reserved.
//

import UIKit

class ReplyViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var wordCountLabel: UILabel!
    @IBOutlet weak var replyTextView: UITextView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var tweetButton: UIButton!
    
    var wordsRemain = 0
    var maxWords = 140
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        wordCountLabel.text = "\(maxWords)"
        profileImage.setImageWith((user?.profileURL)!)
        userNameLabel.text = user?.name
        if let screenName = user?.screenName {
            screenNameLabel.text = "@\(screenName)"
        }
        replyTextView.delegate = self
        replyTextView.becomeFirstResponder()
        print("Reply!")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textViewDidChange(_ textView: UITextView) {
        wordsRemain = maxWords - replyTextView.text.characters.count
        wordCountLabel.text = "\(wordsRemain)"
        if(wordsRemain >= 0) {
            wordCountLabel.textColor = UIColor.black
            tweetButton.isUserInteractionEnabled = true
        } else {
            wordCountLabel.textColor = UIColor.red
            tweetButton.isUserInteractionEnabled = false
        }
    }
    
    @IBAction func dismissView(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func replyTweet(_ sender: Any) {
        TwitterClient.sharedInstance?.replyTweet(text: replyTextView.text, id: (user?.userID)!, success: { (response: Tweet) in
            self.presentingViewController?.dismiss(animated: true, completion: nil)
        }, failure: { (error: Error) in
            print(error.localizedDescription)
        })
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
