//
//  Repository.swift
//  Halaida06
//
//  Created by Mykhailo Halaida on 01.11.2020.
//

import Foundation

class RedditRepository {
    
    static func requestPosts(subreddit: String, listingType: String, limit: Int) {
        HTTPService.makePostRequest(source: RedditSource.Post(subreddit: subreddit, listingType: listingType, limit: limit, after: nil));
    }
    
    static func requestComments(subreddit: String, postId: String) {
        HTTPService.makeCommentRequest(source: RedditSource.Comment(subreddit: subreddit, postId: postId))
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
    
    static func decodePost(respData: Data) -> RedditPostRaw? {
        let jsonDecoder = JSONDecoder();
        do {
            let parsedJSON = try jsonDecoder.decode(RedditPostRaw.self, from: respData);
            return parsedJSON;
        } catch {
            print(error);
            return nil;
        }
    }
    
    static func decodeComment(respData: Data) -> [RedditCommentRaw]? {
        let jsonDecoder = JSONDecoder();
        do {
            var parsedJSON = try jsonDecoder.decode([RedditCommentRaw].self, from: respData);
            parsedJSON.removeFirst();
            return parsedJSON;
        } catch {
            print(error);
            return nil;
        }
    }
    
    static func processRedditPostRaw(rawResJSON: RedditPostRaw) -> [RedditPost] {
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
                    print("Unknown property in RedditPostRaw")
                }
            }
            resResp.append(newPost);
        }
        return resResp;
    }
    
    static func processRedditCommentRaw(rawResJSON: [RedditCommentRaw]) -> [RedditComment] {
        var resResp = [RedditComment]();
        for rawCommentItem in rawResJSON[0].data.children {
            var newComment = RedditComment();
            let mirror = Mirror(reflecting: rawCommentItem.data);
            for rawProp in mirror.children {
                switch rawProp.label {
                case "name":
                    newComment.id = rawProp.value as? String ?? ""
                case "author":
                    newComment.author = rawProp.value as? String ?? ""
                case "created_utc":
                    newComment.created_utc = rawProp.value as? Int ?? 0
                case "body":
                    newComment.body = rawProp.value as? String ?? ""
                case "ups":
                    newComment.ups = rawProp.value as? Int ?? 0
                case "downs":
                    newComment.downs = rawProp.value as? Int ?? 0
                case "permalink":
                    newComment.permalink = "https://www.reddit.com" + (rawProp.value as? String ?? "")
                default:
                    print("Unknown property in RedditCommentRaw")
                }
            }
            resResp.append(newComment);
        }
        return resResp;
    }
    
}

struct LocalRedditPost: Codable {
    var posts: [RedditPost]
}

struct RedditComment: Identifiable, Codable {
    var id: String?
    var author: String?
    var created_utc: Int?
    var body: String?
    var ups: Int?
    var downs: Int?
    var permalink: String?
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

struct RedditCommentRaw: Codable {
    var data: DataStruct
    struct DataStruct: Codable {
        var children: [ItemStruct]
        struct ItemStruct: Codable {
            var data: ItemDataStruct
            struct ItemDataStruct: Codable {
                var name: String //id
                var author: String
                var body: String?
                var permalink: String
                var ups: Int
                var downs: Int
                var created_utc: Int
            }
        }
    }
}

struct RedditPostRaw: Decodable {
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

enum RedditSource {
    case Post(subreddit: String, listingType: String, limit: Int?, after: String?)
    case Comment(subreddit: String, postId: String)
    //other APIs can be handled here
}
