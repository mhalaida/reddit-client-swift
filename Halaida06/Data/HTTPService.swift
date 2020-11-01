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
    static func generateURL(source: HTTPSource) -> String {
        var resStr = "https://";
        switch source {
        case .Reddit(let subreddit, let listingType, let limit, let after):
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
        };
        //other APIs can be handled here
        return resStr;
    };
    
    // generate URL request, send 1)request & 2) completion to HTTPRequester
    static func makeRequest(source: HTTPSource, completion: @escaping (Bool) -> Void) {
        HTTPRequester.requestGET(urlStr: generateURL(source: source), completionHandler: { data in
            if let data = data {
                saveResponse(respData: data, saveCompletion: { (success) -> Void in
                    if (success) {
                        completion(true);
                    } else {
                        print("L'Error")
                    }
                })
            }
        })
    }
        
    // save the Data object to the DB
    static func saveResponse(respData: Data, saveCompletion: (Bool) -> Void) {
        PersistenceManager.shared.cachedResp = respData;
        if PersistenceManager.shared.cachedResp == respData {
            saveCompletion(true);
        } else {
            saveCompletion(false);
        }
    }

}