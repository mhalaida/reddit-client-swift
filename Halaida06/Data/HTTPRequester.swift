//
//  HTTPRequester.swift
//  Halaida06
//
//  Created by Mykhailo Halaida on 01.11.2020.
//

import Foundation

// MARK: HTTPRequester
class HTTPRequester {
    
    //retrieves a JSON from the specified URL
    static func requestGET(urlStr: String, completionHandler: @escaping (Data?) -> Void) {
        guard let url = URL(string: urlStr) else {
            return(print("Error: wrong URL;"));
        };
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print(error);
            }
            if let data = data {
                completionHandler(data);
            }
        }.resume();
    };
    
}
