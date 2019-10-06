//
//  UserProfileHeader.swift
//  InstagramClone
//
//  Created by Ahmed Amr on 7/30/19.
//  Copyright © 2019 Ahmed Amr. All rights reserved.
//

import UIKit

class UserProfileHeader: BaseReusableView {

    var user: User? {
        didSet {
            guard let urlString = user?.profileImageUrl else { return }
            guard let profileImageUrl = URL(string: urlString) else { return }
            self.profileImageView.kf.setImage(with: profileImageUrl)
            usernameLabel.text = user?.username

        }
    }

    static let reuseId = "UserProfileHeaderReuseId"

    let gridButton: UIButton = {
        let button = UIButton.systemButton(image: #imageLiteral(resourceName: "grid"), target: self, selector: #selector(handleGrid))
        return button
    }()
    let listButton: UIButton = {
        let button = UIButton.systemButton(image: #imageLiteral(resourceName: "list"), target: self, selector: #selector(handleList))
        button.tintColor = UIColor(white: 0, alpha: 0.2)
        return button
    }()

    let bookmarkButton: UIButton = {
        let button = UIButton.systemButton(image: #imageLiteral(resourceName: "ribbon"), target: self, selector: #selector(handleBookmark))
        button.tintColor = UIColor(white: 0, alpha: 0.2)
        return button
    }()

    let editProfileButton: UIButton = {
        let button = UIButton.systemButton(title: "Edit Profile", titleColor: .black, backgroundColor: .white, font: UIFont.boldSystemFont(ofSize: 12), target: self, selector: #selector(handleEditProfile))
        button.layer.cornerRadius = 3
        button.clipsToBounds = true
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor(white: 0, alpha: 0.4).cgColor
        return button
    }()

    @objc func handleEditProfile() {

    }
    let postsLabel: UILabel = {
        let label = UILabel(text: "11\nPosts", font: UIFont.systemFont(ofSize: 13), color: .black, textAlignment: .center, numberOfLines: 2)
        let attributedText = NSMutableAttributedString(string: "11\n", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSMutableAttributedString(string: "Posts", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 11), NSAttributedString.Key.foregroundColor: UIColor.black]))
        label.attributedText = attributedText
        return label
    }()
    let followersLabel: UILabel = {
        let label = UILabel(text: "250\nFollowers", font: UIFont.systemFont(ofSize: 13), color: .black, textAlignment: .center, numberOfLines: 2)
        let attributedText = NSMutableAttributedString(string: "250\n", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSMutableAttributedString(string: "Followers", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 11), NSAttributedString.Key.foregroundColor: UIColor.black]))
        label.attributedText = attributedText
        return label
    }()
    let followingLabel: UILabel = {
        let label = UILabel(text: "216\nFollowing", font: UIFont.systemFont(ofSize: 13), color: .black, textAlignment: .center, numberOfLines: 2)
        let attributedText = NSMutableAttributedString(attributedString: NSAttributedString(string: "216\n", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]))
        attributedText.append(NSAttributedString(string: "Following", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 11), NSAttributedString.Key.foregroundColor: UIColor.black]))
        label.attributedText = attributedText
        return label
    }()

    lazy var userStatsStackView = UIStackView(distribution: .fillEqually, arrangedSubviews: [postsLabel, followersLabel, followingLabel])
    lazy var bottomToolBarStackview = UIStackView(distribution: .fillEqually, arrangedSubviews: [gridButton, listButton, bookmarkButton])

    lazy var usernameLabel = UILabel(text: self.user?.username, font: UIFont.boldSystemFont(ofSize: 11), color: .black)

    let profileImageView = UIImageView(image: #imageLiteral(resourceName: "ahmed"), contentMode: .scaleAspectFill)

    override func setupViews() {
        backgroundColor = .background
        addSubviews(profileImageView, bottomToolBarStackview, usernameLabel, userStatsStackView,
                    editProfileButton)
        setupProfileImageView()
        setupBottomToolBar()
        setupUsernameLabel()
        setupUserStatsStackView()
        setupEditProfileButton()
    }

    private func setupProfileImageView() {
        profileImageView.anchor(topAnchor, left: leftAnchor, topConstant: 12, leftConstant: 12, widthConstant: 80, heightConstant: 80)
        profileImageView.roundCircular(width: 80)
    }

    private func setupBottomToolBar() {
        let separatorView = UIView()
        separatorView.backgroundColor = .lightGray
        addSubview(separatorView)

        bottomToolBarStackview.anchor(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, heightConstant: 50)

        separatorView.anchor( left: leftAnchor, bottom: bottomToolBarStackview.topAnchor, right: rightAnchor, heightConstant: 0.5)
    }
    private func setupUsernameLabel() {
        usernameLabel.anchor(profileImageView.bottomAnchor, left: leftAnchor, topConstant: 15, leftConstant: 15)
    }
    private func setupUserStatsStackView() {
        userStatsStackView.anchor(topAnchor, left: profileImageView.rightAnchor, right: rightAnchor, topConstant: 15, leftConstant: 12, rightConstant: 12, heightConstant: 40)
    }
    private func setupEditProfileButton() {
        editProfileButton.anchor(usernameLabel.bottomAnchor, left: leftAnchor, right: rightAnchor, topConstant: 25, leftConstant: 15, rightConstant: 15, heightConstant: 30)
    }

    @objc func handleGrid() {
        print("Grid button")
    }

    @objc func handleList() {
        print("List button")
    }
    @objc func handleBookmark() {
        print("Bookmark button")

    }

}
