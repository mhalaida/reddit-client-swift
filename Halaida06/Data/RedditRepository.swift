//
//  Repository.swift
//  Halaida06
//
//  Created by Mykhailo Halaida on 01.11.2020.
//

import Foundation

class RedditRepository {
    
    static func requestPosts(subreddit: String, listingType: String, limit: Int) {
        HTTPService.makeRequest(source: HTTPSource.Reddit(subreddit: subreddit, listingType: listingType, limit: limit, after: nil));
    }
    
    static func fetchAllPostsFresh() -> [RedditPost] {
        var savedIds = [String]();
        for savedPost in PersistenceManager.shared.savedData {
            savedIds.append(savedPost.id ?? "")
        }
        for (index, freshPost) in PersistenceManager.shared.freshData.enumerated() {
            if savedIds.contains(freshPost.id ?? "") {
                PersistenceManager.shared.freshData[index].isSaved = true;
            }
        }
        return PersistenceManager.shared.freshData;
    }
    
    static func fetchAllPostsSaved() -> [RedditPost] {
        return PersistenceManager.shared.savedData;
    }
    
    static func saveById(id: String) {
        if let saveIndex = PersistenceManager.shared.freshData.firstIndex(where: {$0.id == id}) {
            PersistenceManager.shared.freshData[saveIndex].isSaved = true;
            PersistenceManager.shared.$savedData.mutate {$0.append(PersistenceManager.shared.freshData[saveIndex])};
        } else {
            print(">>Could not find the post to save;")
        }
    }
    
    static func deleteById(id: String) {
        if let freshDeleteIndex = PersistenceManager.shared.freshData.firstIndex(where: {$0.id == id}) {
            PersistenceManager.shared.freshData[freshDeleteIndex].isSaved = false;
        }
        if let deleteIndex = PersistenceManager.shared.savedData.firstIndex(where: {$0.id == id}) {
            PersistenceManager.shared.$savedData.mutate {$0.remove(at: deleteIndex)};
        } else {
            print(">>Could not find the post to delete;")
        }
    }
    
    static func decode(respData: Data) -> RedditResponseRaw? {
        let jsonDecoder = JSONDecoder();
        do {
            let parsedJSON = try jsonDecoder.decode(RedditResponseRaw.self, from: respData);
            return parsedJSON;
        } catch {
            print(error);
            return nil;
        }
    }
    
    static func processRedditRespRaw(rawResJSON: RedditResponseRaw) -> [RedditPost] {
        var resResp = [RedditPost]();
        
        for rawPostItem in rawResJSON.data.children {
            var newPost = RedditPost(author: nil, domain: nil, created_utc: nil, title: nil, url: nil, ups: nil, downs: nil, num_comments: nil, isSaved: false);
            let mirror = Mirror(reflecting: rawPostItem.data);
            for rawProp in mirror.children {
                switch rawProp.label {
                case "permalink":
                    newPost.permalink = "https://www.reddit.com" + (rawProp.value as? String ?? "")
                case "name":
                    newPost.id = rawProp.value as? String ?? ""
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

struct LocalRedditPost: Codable {
    var posts: [RedditPost]
}

struct RedditPost: Codable {
    var id: String?
    var author: String?
    var domain: String?
    var created_utc: Int?
    var title: String?
    var url: String?
    var ups: Int?
    var downs: Int?
    var num_comments: Int?
    var isSaved: Bool
    var permalink: String?
}

struct RedditResponseRaw: Decodable {
    var data: DataStruct
    struct DataStruct: Decodable {
        var children: [ItemStruct]
        struct ItemStruct: Decodable {
            var data: ItemDataStruct
            struct ItemDataStruct: Decodable {
                var name: String // id
                var author: String
                var domain: String
                var created_utc: Int
                var title: String
                var url: String
                var ups: Int
                var downs: Int
                var num_comments: Int
                var permalink: String
            }
        }
    }
}

enum HTTPSource {
    case Reddit(subreddit: String, listingType: String, limit: Int?, after: String?)
    //other APIs can be handled here
}
