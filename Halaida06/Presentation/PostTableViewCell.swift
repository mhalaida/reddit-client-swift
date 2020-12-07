//
//  PostTableViewCell.swift
//  Halaida06
//
//  Created by Mykhailo Halaida on 28.11.2020.
//

import UIKit
import SDWebImage

protocol PostInfoDelegate {
    func passInfo(id: String);
    func sharePost(permalink: String)
}

class PostTableViewCell: UITableViewCell {

    // MARK: - ReuseIdentifier
    static let reuseIdentifier = "postCell"

    // MARK: - Delegate
    var postInfoDelegate: PostInfoDelegate!
    
    // MARK: - ID
    var id: String = "";
    var permalink: String = "";
    
    // MARK: - IBOutlets
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var separator1: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var separator2: UILabel!
    @IBOutlet weak var domainLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var postImageView: UIImageView!
    
    @IBOutlet weak var upvoteButton: UIButton!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var downvoteButton: UIButton!
    @IBOutlet weak var commentsButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    @IBAction func saveButtonAction(_ sender: Any) {
        if (self.saveButton.isSelected) {
            self.saveButton.isSelected = false
            UseCase.deleteById(id: self.id);
        } else {
            self.saveButton.isSelected = true
            UseCase.saveById(id: self.id);
        }
        NotificationCenter.default.post(Notification(name: postSavedByUser))
        //the below notification is to ensure the post is still displayed as saved when scrolled
        NotificationCenter.default.post(Notification(name: freshPostsSaved))
    }
    
    @IBAction func upvoteButtonAction(_ sender: Any) {
        if (self.downvoteButton.isSelected) {
            self.downvoteButton.isSelected = false
        }
        if (self.upvoteButton.isSelected) {
            self.upvoteButton.isSelected = false
        } else {
            self.upvoteButton.isSelected = true
        }
    }
    
    @IBAction func downvoteButtonAction(_ sender: Any) {
        if (self.upvoteButton.isSelected) {
            self.upvoteButton.isSelected = false
        }
        if (self.downvoteButton.isSelected) {
            self.downvoteButton.isSelected = false
        } else {
            self.downvoteButton.isSelected = true
        }
    }
    
    @IBAction func commentsButtonAction(_ sender: Any) {
        postInfoDelegate.passInfo(id: self.id);
    }
    
    @IBAction func shareButtonAction(_ sender: Any) {
        postInfoDelegate.sharePost(permalink: self.permalink);
    }
    
    // MARK: - Lifecycle
    override func prepareForReuse() {
        self.authorLabel.text = nil;
        self.timeLabel.text = nil;
        self.domainLabel.text = nil;
        self.titleLabel.text = nil;
        self.postImageView.image = nil;
        self.ratingLabel.text = nil;
        self.commentsButton.setTitle(nil, for: .normal);
        self.saveButton.isSelected = false;
    }
    
    // MARK: - Configuration
    func configure(for post: RedditPost) {
        self.permalink = post.permalink ?? "https://reddit.com/";
        self.id = post.id ?? "";
        self.separator1.isHidden = false;
        self.separator2.isHidden = false;
        self.authorLabel.text = "u/\(post.author ?? "")"
        self.timeLabel.text = self.formatDate(rawDate: post.created_utc ?? 0)
        self.domainLabel.text = post.domain;
        self.titleLabel.text = post.title;
        self.ratingLabel.text = self.formatRating(rawRating: ((post.ups ?? 0) - (post.downs ?? 0)));
        self.commentsButton.setTitle(self.formatRating(rawRating: post.num_comments ?? 0), for: .normal);
        self.postImageView.sd_setImage(with: URL(string: post.url!), placeholderImage: UIImage());
        if post.isSaved {
            self.saveButton.isSelected = true
        } else {
            self.saveButton.isSelected = false
        }
        let saveGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleSaveDoubleTap));
        saveGestureRecognizer.numberOfTapsRequired = 2;
        self.postImageView.addGestureRecognizer(saveGestureRecognizer);
        self.postImageView.isUserInteractionEnabled = true;
    }
    
    @objc
    func handleSaveDoubleTap() {
        if (self.saveButton.isSelected) {
            self.saveButton.isSelected = false
            UseCase.deleteById(id: self.id);
        } else {
            self.saveButton.isSelected = true
            UseCase.saveById(id: self.id);
        }
        NotificationCenter.default.post(Notification(name: postSavedByUser))
        //the below notification is to ensure the post is still displayed as saved when scrolled
        NotificationCenter.default.post(Notification(name: freshPostsSaved))
    }
    
    func formatRating(rawRating: Int) -> String {
        if (rawRating < 1000) {
            return String(rawRating)
        } else {
            return String(format: "%.1fk", (Float(rawRating) / 1000))
        }
    }
    
    func formatDate(rawDate: Int) -> String {
        let currTime = Int(NSDate().timeIntervalSince1970);
        let timeDiff = currTime - rawDate;
        var timePassed: String;
        
        switch timeDiff {
        case let td where td < 60:
            timePassed = "now";
        case let td where td < 3600:
            timePassed = "\(Int(td/60))m";
        case let td where td < 86400:
            timePassed = "\(Int(td/3600))h";
        case let td where td < 2678400:
            timePassed = "\(Int(td/86400))d";
        case let td where td < 31536000:
            timePassed = "\(Int(td/2678400))m";
        default:
            timePassed = "\(Int(timeDiff/31536000))y";
        }
        return timePassed;
    }

}
