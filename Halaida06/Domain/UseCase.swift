//
//  UseCase.swift
//  Halaida06
//
//  Created by Mykhailo Halaida on 01.11.2020.
//

import Foundation

class UseCase {
    
    static func requestPosts(subreddit: String, listingType: String, limit: Int) {
        RedditRepository.requestPosts(subreddit: subreddit, listingType: listingType, limit: limit);
    };
    
    static func fetchAllPosts() -> [RedditPost] {
        return processRedditRespRaw(rawResJSON: RedditRepository.fetchAllPosts());
    }
    
    static func processRedditRespRaw(rawResJSON: RedditResponseRaw) -> [RedditPost] {
        var resResp = [RedditPost]();
        
        for rawPostItem in rawResJSON.data.children {
            var newPost = RedditPost(author: nil, domain: nil, created_utc: nil, title: nil, url: nil, ups: nil, downs: nil, num_comments: nil, isSaved: false);
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
            resResp.append(newPost);
        }
        return resResp;
    }
    
}

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
