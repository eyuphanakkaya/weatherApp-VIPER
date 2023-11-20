//
//  CacheManager.swift
//  weatherApp
//
//  Created by Eyüphan Akkaya on 20.11.2023.
//

import Foundation


class CacheManager {
    static let shared = CacheManager()
    private let cache =  NSCache<NSString,AnyObject>()
    
    func saveToCache(key: String, data: [String: Any]) {
        let nsKey = NSString(string: key)
        cache.setObject(data as AnyObject, forKey: nsKey)
    }
    func getFromCache(key: String) -> [String: Any]? {
        let nsKey = NSString(string: key)
        if let cachedData = cache.object(forKey: nsKey) as? [String: Any] {
            return cachedData
        }
        return nil
    }
}
