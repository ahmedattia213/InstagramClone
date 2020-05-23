//
//  Post.swift
//  InstagramClone
//
//  Created by Ahmed Amr on 9/29/19.
//  Copyright © 2019 Ahmed Amr. All rights reserved.
//

import Foundation

struct Post {
    var key: String?
    var user: User
    var caption: String
    var creationDate: Date
    var imageHeight: Int
    var imageWidth: Int
    var postUrl: String
    var isLiked: Bool = false
    init(user: User, dictionary: [String: Any]) {
        self.user = user
        caption = dictionary["caption"] as? String ?? ""
        let secondsFrom1970 = dictionary["creationDate"] as? Double ?? 0
        creationDate = Date(timeIntervalSince1970: secondsFrom1970)
        imageHeight = dictionary["imageHeight"] as? Int ?? 0
        imageWidth = dictionary["imageWidth"] as? Int ?? 0
        postUrl = dictionary["postUrl"] as? String ?? ""
    }

    static func == (lhs: Post, rhs: Post) -> Bool {
        return lhs.user == rhs.user && lhs.caption == rhs.caption && lhs.creationDate == rhs.creationDate
            && lhs.imageHeight == rhs.imageHeight
            && lhs.imageWidth == rhs.imageWidth
            && lhs.postUrl == rhs.postUrl
    }
}
