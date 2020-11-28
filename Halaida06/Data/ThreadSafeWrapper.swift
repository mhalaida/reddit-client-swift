//
//  ThreadSafeWrapper.swift
//  Halaida06
//
//  Created by Mykhailo Halaida on 28.11.2020.
//

import Foundation

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
