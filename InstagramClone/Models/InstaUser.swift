//
//  User.swift
//  InstagramClone
//
//  Created by Ahmed Amr on 10/4/19.
//  Copyright © 2019 Ahmed Amr. All rights reserved.
//

import Foundation

class User: NSObject {

    var username: String?
    var profileImageUrl: String?

    init(dictionary: [String: Any]) {
        super.init()
        username = dictionary["username"] as? String ?? ""
        profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
    }

    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.username == rhs.username && lhs.profileImageUrl == rhs.profileImageUrl
    }
}
