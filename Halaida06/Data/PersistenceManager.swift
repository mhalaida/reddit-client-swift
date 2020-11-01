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

@propertyWrapper
class ThreadSafe<T> {
    
    private var value: T;
    private let queue = DispatchQueue(label: "threadsafe");
    
    var wrappedValue: T {
        get {
            return queue.sync {
                return value;
            }
        }
        set {
            queue.sync {
                value = newValue;
            }
        }
    };
    
    var projectedValue: ThreadSafe<T> {
        return self;
    };
    
    func mutate(_ mutation: (inout T) -> Void) {
        return queue.sync {
            mutation(&value)
        }
    };
    
    init(wrappedValue: T) {
        self.value = wrappedValue;
    };
}
