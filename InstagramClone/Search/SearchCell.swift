//
//  SearchCell.swift
//  InstagramClone
//
//  Created by Ahmed Amr on 1/27/20.
//  Copyright © 2020 Ahmed Amr. All rights reserved.
//

import UIKit
import Kingfisher

class SearchCell: BaseCollectionViewCell {

    var user: User? {
        didSet {
            setupUserCell()
        }
    }

    let userProfileImage: UIImageView = UIImageView(image: nil, contentMode: .scaleAspectFill, cornerRadius: 20, userInteraction: true)
    let usernameLabel: UILabel = UILabel(text: "esmy ahmed", font: UIFont.boldSystemFont(ofSize: 14), color: .black)
    let separatorView = UIView(color: .lightGray)

    static let reuseIdentifier = "SearchCellReuseId"
    override func setupViews() {
        self.addSubviews(userProfileImage, usernameLabel, separatorView)
        userProfileImage.anchor(left: self.leftAnchor, leftConstant: 12, widthConstant: 40, heightConstant: 40, centerYInSuperView: true)
        usernameLabel.anchor(left: userProfileImage.rightAnchor, right: self.rightAnchor, leftConstant: 12, heightConstant: 20)
        usernameLabel.anchorCenterYToSuperview(constant: -7)
        separatorView.anchor(left: usernameLabel.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, rightConstant: 20, heightConstant: 0.5)
    }

    private func setupUserCell() {
        usernameLabel.text = user?.username
        guard let url = URL(string: self.user?.profileImageUrl ?? "") else { return }
        userProfileImage.kf.setImage(with: url)
    }
}
