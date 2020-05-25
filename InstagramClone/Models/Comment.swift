//
//  Comment.swift
//  InstagramClone
//
//  Created by Ahmed Amr on 5/22/20.
//  Copyright © 2020 Ahmed Amr. All rights reserved.
//

import Foundation

struct Comment {
    var key: String? 
    var user: User
    var text: String
    var uid: String
    var timeStamp: Date
    init(user: User, dictionary: [String: Any]) {
        self.user = user
        self.text = dictionary["text"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
        let secondsFrom1970 = dictionary["timeStamp"] as? Double ?? 0
        timeStamp = Date(timeIntervalSince1970: secondsFrom1970)
    }
}
