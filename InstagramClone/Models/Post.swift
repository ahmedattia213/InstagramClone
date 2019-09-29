//
//  Post.swift
//  InstagramClone
//
//  Created by Ahmed Amr on 9/29/19.
//  Copyright © 2019 Ahmed Amr. All rights reserved.
//

import Foundation

class Post: NSObject {

    var caption: String?
    var creationDate: NSNumber?
    var imageHeight: NSNumber?
    var imageWidth: NSNumber?
    var postUrl: String?

    init(dictionary: [String: Any]) {
        super.init()
        caption = dictionary["caption"] as? String
        creationDate = dictionary["creationDate"] as? NSNumber
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
