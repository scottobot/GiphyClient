//
//  GifCache.swift
//  GiphyClient
//
//  Created by Scott Doerrfeld on 9/5/17.
//  Copyright © 2017 Scott Doerrfeld. All rights reserved.
//

import Foundation

class GifCache {
    static let shared = GifCache()
    
    private var cache: [String: Data] = [:]
    
    private init() {}
    
    func store(_ key: String, data: Data?) {
        self.cache[key] = data
    }
    
    func retrieve(_ key: String) -> Data? {
        return self.cache[key]
    }
    
    func purge() {
        self.cache.removeAll()
    }
}
