//
//  User.swift
//  InstagramClone
//
//  Created by Ahmed Amr on 10/4/19.
//  Copyright © 2019 Ahmed Amr. All rights reserved.
//

import Foundation

struct User {

    let uid: String
    var username: String
    var profileImageUrl: String

    init(uid: String, dictionary: [String: Any]) {
        self.uid = uid
        username = dictionary["username"] as? String ?? ""
        profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
    }

    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.uid == rhs.uid
    }
}
