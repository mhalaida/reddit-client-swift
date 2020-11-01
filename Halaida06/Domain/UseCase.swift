//
//  UseCase.swift
//  Halaida06
//
//  Created by Mykhailo Halaida on 01.11.2020.
//

import Foundation

class UseCase {
    
    static func getTop10RedditPosts(subreddit: String) {
        
        RedditRepository.getTop10Posts(subreddit: subreddit, completion: { (success) -> Void in
            if success {
                if let result = RedditRepository.decode(respData: PersistenceManager.shared.cachedResp) {
                    processRedditResp(resJSON: result);
//                    for post in result.data.children {
//                        print(post.data.author);
//                        print(post.data.created_utc);
//                        print(post.data.domain);
//                        print(post.data.title);
//                        print(post.data.url);
//                        print(post.data.ups);
//                        print(post.data.downs);
//                        print(post.data.num_comments);
//                    }
                }
            } else {
                print("Bruh error");
            }
        });
    };
    
    //processes & outputs the response received from Reddit API
    static func processRedditResp(resJSON: RedditResponse) {

        var finalStr = ">>> Listing length: \(resJSON.data.children.count)";
        finalStr += "\n>>> Listing posts:"

        for (index, post) in resJSON.data.children.enumerated() {

            finalStr += "\n\n\t[\(index+1)]:"
            finalStr += "\n\t  username: \(post.data.author)"

            let currTime = Int(NSDate().timeIntervalSince1970);
            let timeDiff = currTime - post.data.created_utc;
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

            finalStr += "\n\t  time passed: \(timePassed)";
            finalStr += "\n\t  domain: \(post.data.domain)";
            finalStr += "\n\t  title: \(post.data.title)";
            finalStr += "\n\t  image: \(post.data.url)";
            finalStr += "\n\t  rating: \(post.data.ups - post.data.downs)";
            finalStr += "\n\t  num_comments: \(post.data.num_comments)";
        }
        print(finalStr);
    };
    
}
