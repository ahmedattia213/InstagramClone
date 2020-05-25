//
//  UserProfileHeader.swift
//  InstagramClone
//
//  Created by Ahmed Amr on 7/30/19.
//  Copyright © 2019 Ahmed Amr. All rights reserved.
//

import UIKit
import FirebaseAuth

class UserProfileHeader: BaseReusableView {

    var user: User? {
        didSet {
            guard let urlString = user?.profileImageUrl else { return }
            guard let profileImageUrl = URL(string: urlString) else { return }
            self.profileImageView.kf.setImage(with: profileImageUrl)
            usernameLabel.text = user?.username
            checkIfUserIsCurrent()
            setupEditFollowButton()
            setupFollowingAndFollowersLabel()
            setupPostsLabel()
        }
    }
    private func setupPostsLabel() {
        let postsAttributedText = NSMutableAttributedString(string: "\(user?.posts ?? 0)\n", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
        postsAttributedText.append(NSMutableAttributedString(string: "Posts", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 11), NSAttributedString.Key.foregroundColor: UIColor.black]))
        postsLabel.attributedText = postsAttributedText
    }
    private func setupFollowingAndFollowersLabel() {
        let followersAttributedText = NSMutableAttributedString(string: "\(user?.followerCount ?? 0)\n", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
        followersAttributedText.append(NSMutableAttributedString(string: "Followers", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 11), NSAttributedString.Key.foregroundColor: UIColor.black]))
        followersLabel.attributedText = followersAttributedText
        let followingAttributedText = NSMutableAttributedString(string: "\(user?.followingCount ?? 0)\n", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
        followingAttributedText.append(NSMutableAttributedString(string: "Following", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 11), NSAttributedString.Key.foregroundColor: UIColor.black]))
        followingLabel.attributedText = followingAttributedText
    }

    static let reuseId = "UserProfileHeaderReuseId"

    var userFollowed: Bool? = nil {
        didSet {
            if let userFollowed = userFollowed {
                if userFollowed {
                    setupButtonToUnfollow()
                }
            } else {
                setupButtonToFollow()
            }
        }
    }

    var userIsCurrent: Bool = false

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
        let button = UIButton.systemButton(title: "Edit Profile", titleColor: .black, backgroundColor: .white, font: UIFont.boldSystemFont(ofSize: 12), target: self, selector: #selector(handleEditOrFollow))
        button.layer.cornerRadius = 3
        button.clipsToBounds = true
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor(white: 0, alpha: 0.4).cgColor
        return button
    }()

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
//    lazy var bottomToolBarStackview = UIStackView(distribution: .fillEqually, arrangedSubviews: [gridButton, listButton, bookmarkButton])
    lazy var bottomToolBarStackview = UIStackView(distribution: .fillEqually, arrangedSubviews: [gridButton, bookmarkButton])

    lazy var usernameLabel = UILabel(text: self.user?.username, font: UIFont.boldSystemFont(ofSize: 11), color: .black)

    let profileImageView = UIImageView(image: #imageLiteral(resourceName: "ahmed"), contentMode: .scaleAspectFill)

    override func setupViews() {
        setupUI()

    }

    private func setupUI() {
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

    @objc func handleEditOrFollow() {
        if userIsCurrent {
            goToEditProfile()
        } else {
            if self.userFollowed != nil {
                unfollowUser()

            } else {
                followUser()
            }
        }
    }

    private func unfollowUser() {
        guard let currentUserUid = Auth.auth().currentUser?.uid else { return }
        guard let userId = self.user?.uid else { return }
        let followingRef = FirebaseHelper.usersFollowing.child(currentUserUid).child(userId)
        let followerRef = FirebaseHelper.usersFollowers.child(userId).child(currentUserUid)
        followingRef.removeValue { (err, _) in
            if let err = err {
                print("Couldnt unfollow user ", err)
                return
            }
            self.userFollowed = nil
            print("Successfully unfollowed user")
            followerRef.removeValue { (err, _) in
                if let err = err {
                    print("Couldnt remove from followers: ", err)
                    return
                }
                print("Successfully removed from user's followers")
            }
        }
    }
    private func followUser() {
        guard let currentUserUid = Auth.auth().currentUser?.uid else { return }
        guard let userId = self.user?.uid else { return }
        let followingRef = FirebaseHelper.usersFollowing.child(currentUserUid)
        let followersRef = FirebaseHelper.usersFollowers.child(userId)
        let followingValues = [userId: true]
        let followerValues = [currentUserUid: true]
        followingRef.updateChildValues(followingValues) { (err, _) in
            if let err = err {
                print("Failed to follow user: ", err)
                return
            }
            self.userFollowed = true
            print("Successfully followed user: ", self.user?.username ?? "")
            followersRef.updateChildValues(followerValues) { (err, ref) in
                if let err = err {
                    print("Failed to add user to followers: ", err)
                    return
                }
                print("User added to followers successfully")
            }
        }
    }
    private func goToEditProfile() {

    }

    @objc func checkIfFollowing() {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        guard let userUid = self.user?.uid else { return }
        let currentFollwingRef = FirebaseHelper.usersFollowing.child(currentUid).child(userUid)
        currentFollwingRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let following = snapshot.value as? Bool, following {
                self.userFollowed = true
            } else {
                self.userFollowed = nil
            }
        }) { (err) in
            print("Failed to retrieve following for user: ", err)
        }
    }

    private func setupEditFollowButton() {
        if userIsCurrent {
            setupButtonToEditProfile()

        } else {
            setupButtonToFollow()
            checkIfFollowing()
        }
    }

    private func checkIfUserIsCurrent() {
        guard let currentUserUid = Auth.auth().currentUser?.uid else { return }
        guard let userId = self.user?.uid else { return }
        if userId != currentUserUid {
            userIsCurrent = false
        } else {
            userIsCurrent = true
        }
    }

    private func setupButtonToFollow() {
        editProfileButton.setTitle("Follow", for: .normal)
        editProfileButton.backgroundColor = UIColor.followButton
        editProfileButton.setTitleColor(UIColor.followText, for: .normal)
        editProfileButton.layer.borderWidth = 0
    }

    private func setupButtonToUnfollow() {
        editProfileButton.setTitle("Unfollow", for: .normal)
        editProfileButton.backgroundColor = UIColor.unfollowButton
        editProfileButton.setTitleColor(UIColor.unfollowText, for: .normal)
        editProfileButton.layer.borderWidth = 0.8
        editProfileButton.layer.borderColor = (UIColor.unfollowButtonBorder).cgColor
    }

    private func setupButtonToEditProfile() {
        editProfileButton.setTitle("Edit Profile", for: .normal)
        editProfileButton.backgroundColor = UIColor.unfollowButton
        editProfileButton.setTitleColor(UIColor.unfollowText, for: .normal)
        editProfileButton.layer.borderWidth = 0.8
        editProfileButton.layer.borderColor = (UIColor.unfollowButtonBorder).cgColor
    }

}
