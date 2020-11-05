//
//  ViewController.swift
//  Halaida06
//
//  Created by Mykhailo Halaida on 01.11.2020.
//

import UIKit
import SDWebImage

class PostViewController: UIViewController {
    
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var separator1: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var separator2: UILabel!
    @IBOutlet weak var domainLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var commentsButton: UIButton!
    
    @IBOutlet weak var saveButton: UIButton!
    @IBAction func saveButtonAction(_ sender: Any) {
        if (self.saveButton.isSelected) {
            self.saveButton.isSelected = false
        } else {
            self.saveButton.isSelected = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UseCase.getTop10RedditPosts(subreddit: "dankmemes", completionUseCase: {(data) -> Void in
            DispatchQueue.main.async {
                self.separator1.isHidden = false;
                self.separator2.isHidden = false;
                self.authorLabel.text = "u/\(data.data[0].author ?? "")"
                self.timeLabel.text = self.formatDate(rawDate: data.data[0].created_utc ?? 0)
                self.domainLabel.text = data.data[0].domain;
                self.titleLabel.text = data.data[0].title;
                self.ratingLabel.text = self.formatRating(rawRating: ((data.data[0].ups ?? 0) - (data.data[0].downs ?? 0)));
                self.commentsButton.setTitle(self.formatRating(rawRating: data.data[0].num_comments ?? 0), for: .normal)
                self.imageView.sd_setImage(with: URL(string: data.data[0].url!), placeholderImage: UIImage())
            }
        })
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

