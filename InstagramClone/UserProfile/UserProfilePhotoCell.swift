//
//  UserProfilePhotoCell.swift
//  InstagramClone
//
//  Created by Ahmed Amr on 9/29/19.
//  Copyright © 2019 Ahmed Amr. All rights reserved.
//

import UIKit

class UserProfilePhotoCell: BaseCollectionViewCell {
    var post: Post? {
        didSet {
            guard let postUrl = URL(string: post?.postUrl ?? "") else { return }
            self.postImageView.kf.setImage(with: postUrl)
        }
    }
    static let reuseIdentifier = "userProfilePhotoCellReuseId"
    let postImageView: UIImageView = UIImageView(image: nil, contentMode: .scaleAspectFill, userInteraction: true)
    override func setupViews() {
        self.addSubview(postImageView)
        postImageView.fillSuperview()
    }
}
