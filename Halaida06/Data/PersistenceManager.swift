//
//  RedditPersistenceManager.swift
//  Halaida06
//
//  Created by Mykhailo Halaida on 01.11.2020.
//

import Foundation

let postSavedByUser = Notification.Name("RedditPostSaved")

// MARK: A singleton serving as the last cached response storage
class PersistenceManager: ObservableObject {
    
    static var shared = PersistenceManager();
    
    @ThreadSafe var freshData: [RedditPost] {
        didSet {
            print(">>A new response has been saved;")
        }
    };
    
    @ThreadSafe var savedData: [RedditPost];
    @Published var freshComments: [RedditComment];
    
    private init() {
        freshData = [RedditPost]();
        savedData = [RedditPost]();
        freshComments = [
            RedditComment(id: "1", author: "bruh1", created_utc: 12345, body: "bruh bruh bruh bruhb ruhbruhbruh rubh ", ups: 534, downs: 0),
            RedditComment(id: "2", author: "bruh2", created_utc: 64572, body: "nartjevrjbryjerdyjkveryjkv", ups: 756, downs: 0),
            RedditComment(id: "3", author: "bruh3", created_utc: 17357, body: "164134646 2361346 ", ups: 512, downs: 0),
        ]
        NotificationCenter.default.addObserver(self, selector: #selector(triggerSaveJSON), name: postSavedByUser, object: nil);
    };
    
    @objc
    func triggerSaveJSON() {
        self.saveJSON();
    }
    
    func saveJSON() {
        do {
            var dataLS = LocalRedditPost(posts: []);
            for savedPost in self.savedData {
                dataLS.posts.append(savedPost);
            }
            print(self.savedData)
            print(dataLS)
            let sData = try JSONEncoder().encode(dataLS);
            do {
                try sData.write(to: self.getFileURL())
                print(">>Data written to filesystem succesfully;")
            } catch {
                print("Error writing the data locally;")
            }
        } catch {
            print(">>Error encoding the data;")
        }
    }
    
    func loadJSON() {
        do {
            let localData = try Data(contentsOf: self.getFileURL());
            let jsonDecoder = JSONDecoder();
            let loadedData = try jsonDecoder.decode(LocalRedditPost.self, from: localData);
            for localPost in loadedData.posts {
                self.savedData.append(localPost)
            }
            print(">>Data loaded from the filesystem succesfully;")
        } catch {
            print(">>Error loading the data from the filesystem;")
        }
    }
    
    func getFileURL() -> URL {
        let dirURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0];
        return URL(fileURLWithPath: "saveddata", relativeTo: dirURL);
    }
        
}
