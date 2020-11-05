//
//  UseCase.swift
//  Halaida06
//
//  Created by Mykhailo Halaida on 01.11.2020.
//

import Foundation

class UseCase {
    
    static func getTop10RedditPosts(subreddit: String, completionUseCase: @escaping (RedditResponse) -> Void) {
        
        RedditRepository.getTop10Posts(subreddit: subreddit, completion: { (success) -> Void in
            if success {
                if let result = RedditRepository.decode(respData: PersistenceManager.shared.cachedResp) {
                    let processedResult = processRedditRespRaw(rawResJSON: result);
                    completionUseCase(processedResult);
                }
            } else {
                print("Bruh error");
            }
        });
    };
    
    static func processRedditRespRaw(rawResJSON: RedditResponseRaw) -> RedditResponse {
        var resResp = RedditResponse(data: []);
        
        for rawPostItem in rawResJSON.data.children {
            var newPost = RedditResponse.RedditPost(author: nil, domain: nil, created_utc: nil, title: nil, url: nil, ups: nil, downs: nil, num_comments: nil, isSaved: false);
            let mirror = Mirror(reflecting: rawPostItem.data);
            for rawProp in mirror.children {
                switch rawProp.label {
                case "author":
                    newPost.author = rawProp.value as? String ?? ""
                case "domain":
                    newPost.domain = rawProp.value as? String ?? ""
                case "created_utc":
                    newPost.created_utc = rawProp.value as? Int ?? 0
                case "title":
                    newPost.title = rawProp.value as? String ?? ""
                case "url":
                    newPost.url = rawProp.value as? String ?? ""
                case "ups":
                    newPost.ups = rawProp.value as? Int ?? 0
                case "downs":
                    newPost.downs = rawProp.value as? Int ?? 0
                case "num_comments":
                    newPost.num_comments = rawProp.value as? Int ?? 0
                default:
                    print("Unknown property in RedditResponseRaw")
                }
            }
            resResp.data.append(newPost);
        }
        return resResp;
    }
    
    //processes & outputs the response received from Reddit API
    static func showRedditResp(resJSON: RedditResponse) {
        
        var finalStr = ">>> Listing length: \(resJSON.data.count)";
        finalStr += "\n>>> Listing posts:"
        
        for (index, post) in resJSON.data.enumerated() {
            
            finalStr += "\n\n\t[\(index+1)]:"
            finalStr += "\n\t  username: \(post.author ?? "")"
            
            let currTime = Int(NSDate().timeIntervalSince1970);
            let timeDiff = currTime - (post.created_utc ?? 0);
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
            finalStr += "\n\t  domain: \(post.domain ?? "")";
            finalStr += "\n\t  title: \(post.title ?? "")";
            finalStr += "\n\t  image: \(post.url ?? "")";
            finalStr += "\n\t  rating: \((post.ups ?? 0) - (post.downs ?? 0))";
            finalStr += "\n\t  num_comments: \(post.num_comments ?? 0)";
        }
        print(finalStr);
    };
    
}

struct RedditResponse {
    var data: [RedditPost]
    struct RedditPost: Decodable {
        var author: String?
        var domain: String?
        var created_utc: Int?
        var title: String?
        var url: String?
        var ups: Int?
        var downs: Int?
        var num_comments: Int?
        var isSaved: Bool
    }
}
