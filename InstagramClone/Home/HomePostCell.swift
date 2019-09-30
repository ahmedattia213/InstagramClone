//
//  HomePostCell.swift
//  InstagramClone
//
//  Created by Ahmed Amr on 9/30/19.
//  Copyright © 2019 Ahmed Amr. All rights reserved.
//

import UIKit

class HomePostCell: BaseCollectionViewCell {
    static let reuseIdentifier = "HomePostCellReuseId"

    let postProfileImageView: UIImageView = UIImageView(image: nil, contentMode: .scaleAspectFill)
    let postUsernameLabel: UILabel = UILabel(text: "7amada", font: UIFont.boldSystemFont(ofSize: 13), color: .black)
    let settingsImageView: UIImageView = UIImageView(image: nil, contentMode: .scaleAspectFill, tintColour: nil, userInteraction: true)
    let bookmarkImageView: UIImageView = UIImageView(image: nil, contentMode: .scaleAspectFill, tintColour: nil, userInteraction: true)

    lazy var profileDetailsContainer: UIView = {
       let view = UIView()
        view.addSubviews(postProfileImageView, postUsernameLabel, settingsImageView)
        self.postProfileImageView.anchor(left: view.leftAnchor, leftConstant: 6, widthConstant: 30, heightConstant: 30, centerYInSuperView: true)
        self.postProfileImageView.roundCircular(width: 30)
        self.postUsernameLabel.anchor(left: self.postProfileImageView.rightAnchor, leftConstant: 4, widthConstant: 100, heightConstant: 20, centerYInSuperView: true)
        self.settingsImageView.anchor(right: view.rightAnchor, rightConstant: 7, widthConstant: 25, heightConstant: 25, centerYInSuperView: true)
        return view
    }()

    lazy var likeCommentDmContainer: UIView = {
        let view = UIView()
        view.addSubviews(likeCommentDmStackView,bookmarkImageView)
        likeCommentDmStackView.anchor(left: view.leftAnchor, leftConstant: 10, widthConstant: 150, heightConstant: 25, centerYInSuperView: true)
        bookmarkImageView.anchor(right: view.rightAnchor, rightConstant: 7, widthConstant: 25, heightConstant: 25, centerYInSuperView: true)
        return view
    }()

    let postImageView = UIImageView(image: nil, contentMode: .scaleAspectFill, userInteraction: true)

    let likeCommentContainer = UIView()

    let likeImageView = UIImageView(image: nil, contentMode: .scaleAspectFill, tintColour: nil, userInteraction: true)
    let commentImageView = UIImageView(image: nil, contentMode: .scaleAspectFill, tintColour: nil, userInteraction: true)
    let dmImageView = UIImageView(image: nil, contentMode: .scaleAspectFill, tintColour: nil, userInteraction: true)

    lazy var likeCommentDmStackView = UIStackView(axis: .horizontal, alignment: .fill, distribution: .fillEqually, spacing: 20, arrangedSubviews: [likeImageView, commentImageView, dmImageView])

    override func setupViews() {
        //removeOldViews()
        super.setupViews()
        setupProfileDetailsContainer()
        setupLikeCommentDmContainer()
        setupPostImageView()
        self.backgroundColor = .white
    }
    private func removeOldViews() {
        for view in self.subviews {
            view.removeFromSuperview()
        }

    }
    private func setupProfileDetailsContainer() {
        self.addSubview(profileDetailsContainer)
        profileDetailsContainer.anchor(self.topAnchor, left: self.leftAnchor, right: self.rightAnchor, heightConstant: 50)
        postProfileImageView.backgroundColor = .red
        settingsImageView.backgroundColor = .blue
        profileDetailsContainer.backgroundColor = .background
    }
    
    private func setupLikeCommentDmContainer() {
        self.addSubview(likeCommentDmContainer)
        likeCommentDmContainer.anchor(left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, heightConstant: 50)
        likeImageView.backgroundColor = .brown
        commentImageView.backgroundColor = .cyan
        dmImageView.backgroundColor = .green
        bookmarkImageView.backgroundColor = .dimmedSignupButton
    }
    
    private func setupPostImageView() {
        self.addSubview(postImageView)
        postImageView.anchor(profileDetailsContainer.bottomAnchor, left: self.leftAnchor, bottom: likeCommentDmStackView.topAnchor, right: self.rightAnchor)
        postImageView.backgroundColor = .lightGray
    }
}
