//
//  UserDefaults+Helper.swift
//  InstagramClone
//
//  Created by Ahmed Amr on 5/25/20.
//  Copyright © 2020 Ahmed Amr. All rights reserved.
//

import Foundation

enum UserDefaultKeys: String{
    case followers = "followers"
    case following = "following"
}

class UserDefaultsHelpers {
    static let defaults = UserDefaults.standard
    
    static func set(value : Any , key : String){
        defaults.set(value, forKey: key)
        defaults.synchronize()
    }
    
    static func get( key : String ) -> Any? {
        if let thing = defaults.value(forKey: key) {
            return thing
        }
        return nil
    }
    
    static func remove( key : String ) {
        defaults.removeObject(forKey: key)
        defaults.synchronize()
    }
    
    static func setObj<T>(object: T, key: String) where T: Encodable {
        
        let defaults = UserDefaults.standard
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(object) {
            defaults.set(encoded, forKey: key)
            defaults.synchronize()
        }
    }
    
    static func getObj<T>(object: T.Type, key: String) -> T? where T: Decodable {
        
        let decoder = JSONDecoder()
        if let objectData = UserDefaults.standard.data(forKey: key),
            let value = try? decoder.decode(object.self, from: objectData) {
            return value
        }
        
        return nil
    }
}
