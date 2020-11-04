//
//  Repository.swift
//  Halaida06
//
//  Created by Mykhailo Halaida on 01.11.2020.
//

import Foundation

class RedditRepository {
    
    static func getTop10Posts(subreddit: String, completion: @escaping (Bool) -> Void) {
        // ... sending the request, waiting till the response is written to the DB, after which completion handler:
        HTTPService.makeRequest(source: HTTPSource.Reddit(subreddit: subreddit, listingType: "top", limit: 10, after: nil), completion: { (success) -> Void in
            if success {
                completion(true);
            } else {
                print("L'Error")
            }
        })
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
