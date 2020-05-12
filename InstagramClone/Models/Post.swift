//
//  Post.swift
//  InstagramClone
//
//  Created by Ahmed Amr on 9/29/19.
//  Copyright © 2019 Ahmed Amr. All rights reserved.
//

import Foundation

class Post: NSObject {

    var user: User?
    var caption: String?
    var creationDate: Date?
    var imageHeight: NSNumber?
    var imageWidth: NSNumber?
    var postUrl: String?

    init(user: User, dictionary: [String: Any]) {
        super.init()
        self.user = user
        caption = dictionary["caption"] as? String
        let secondsFrom1970 = dictionary["creationDate"] as? Double ?? 0
        creationDate = Date(timeIntervalSince1970: secondsFrom1970)
        imageHeight = dictionary["imageHeight"] as? NSNumber
        imageWidth = dictionary["imageWidth"] as? NSNumber
        postUrl = dictionary["postUrl"] as? String
    }

    static func == (lhs: Post, rhs: Post) -> Bool {
        return lhs.caption == rhs.caption && lhs.creationDate == rhs.creationDate
            && lhs.imageHeight == rhs.imageHeight
            && lhs.imageWidth == rhs.imageWidth
            && lhs.postUrl == rhs.postUrl
    }
}
