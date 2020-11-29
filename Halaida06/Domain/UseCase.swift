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
        return RedditRepository.fetchAllPosts();
    }
    
    static func saveById(id: String) {
        RedditRepository.saveById(id: id);
    }
    
    static func deleteById(id: String) {
        RedditRepository.deleteById(id: id);
    }
    
}
