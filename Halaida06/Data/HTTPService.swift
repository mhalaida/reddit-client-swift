//
//  RedditHTTPService.swift
//  Halaida06
//
//  Created by Mykhailo Halaida on 01.11.2020.
//

import Foundation

// MARK: HTTPService
class HTTPService {
    
    //generates the URL string which is then passed to requestGET
    static func generateURL(source: RedditSource) -> String {
        var resStr = "https://";
        switch source {
        case .Post(let subreddit, let listingType, let limit, let after):
            resStr += "www.reddit.com/r/\(subreddit)/\(listingType).json";
            if limit != nil || after != nil {
                resStr += "?";
            };
            if limit != nil {
                if limit! < 1 {
                    print("Error: wrong parameter format;")
                    return "";
                }
                resStr += "limit=\(limit!)";
            };
            if after != nil {
                if limit != nil {
                    resStr += "&";
                };
                resStr += "after=\(after!)";
            };
        case .Comment(let subreddit, let postId):
            resStr += "www.reddit.com/r/\(subreddit)/comments/\(postId)/.json"
        };
        //other APIs can be handled here
        return resStr;
    };
    
    // generate URL request, send 1)request & 2) completion to HTTPRequester
    static func makePostRequest(source: RedditSource) {
        HTTPRequester.requestGET(urlStr: generateURL(source: source), completionHandler: { data in
            if let data = data {
                savePostResponse(respData: data)
            }
        })
    }
    
    static func makeCommentRequest(source: RedditSource) {
        HTTPRequester.requestGET(urlStr: generateURL(source: source), completionHandler: { data in
            if let data = data {
//                print(data);
                saveCommentsResponse(respData: data)
            }
        })
    }
        
    // save the Data object to the DB
    static func savePostResponse(respData: Data) {
        PersistenceManager.shared.freshData = RedditRepository.processRedditPostRaw(rawResJSON: RedditRepository.decodePost(respData: respData) ?? RedditPostRaw(data: RedditPostRaw.DataStruct(children: [])));
        NotificationCenter.default.post(Notification(name: freshPostsSaved))
    }
    
    static func saveCommentsResponse(respData: Data) {
        PersistenceManager.shared.freshComments = RedditRepository.processRedditCommentRaw(rawResJSON: RedditRepository.decodeComment(respData: respData) ?? [RedditCommentRaw]());
        NotificationCenter.default.post(Notification(name: freshCommentsSaved))
        print(PersistenceManager.shared.freshComments)
//        var bruh = RedditRepository.decodeComment(respData: respData);
//        bruh?.removeFirst();
//        print(bruh)
//        print(RedditRepository.decodeCommentBruh(respData: bruh));
//        PersistenceManager.shared.freshComments = RedditRepository.processRedditRespRaw(rawResJSON: RedditRepository.decode(respData: respData) ?? RedditPostRaw(data: RedditPostRaw.DataStruct(children: [])));
//        NotificationCenter.default.post(Notification(name: freshPostsSaved))
    }

}
