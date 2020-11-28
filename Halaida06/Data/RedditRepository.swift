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
    
    static func fetchAllPosts() -> RedditResponseRaw {
        guard let result = decode(respData: PersistenceManager.shared.cachedResp) else {
            return RedditResponseRaw(data: RedditResponseRaw.DataStruct(children: []))
        }
        return result;
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
    
}

struct RedditResponseRaw: Decodable {
    var data: DataStruct
    struct DataStruct: Decodable {
        var children: [ItemStruct]
        struct ItemStruct: Decodable {
            var data: ItemDataStruct
            struct ItemDataStruct: Decodable {
                var author: String
                var domain: String
                var created_utc: Int
                var title: String
                var url: String
                var ups: Int
                var downs: Int
                var num_comments: Int
            }
        }
    }
}

enum HTTPSource {
    case Reddit(subreddit: String, listingType: String, limit: Int?, after: String?)
    //other APIs can be handled here
}
