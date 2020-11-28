//
//  RedditPersistenceManager.swift
//  Halaida06
//
//  Created by Mykhailo Halaida on 01.11.2020.
//

import Foundation

// MARK: A singleton serving as the last cached response storage
class PersistenceManager {
    
    static var shared = PersistenceManager();
    
    @ThreadSafe var cachedResp: Data {
        didSet {
            print(">>The response has been cached;")
        }
    };
    
    private init() {
        cachedResp = Data();
    };
        
}
