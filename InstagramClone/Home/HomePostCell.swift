//
//  HomePostCell.swift
//  InstagramClone
//
//  Created by Ahmed Amr on 9/30/19.
//  Copyright © 2019 Ahmed Amr. All rights reserved.
//

import UIKit

protocol HomePostCellDelegate: class {
    func didTapCommentWithPost(_ post: Post)
    func didTapSettings()
    func didTapLike(for cell: HomePostCell)
    func didTapSendDm()
    func didTapBookmark()
    func didTapViewComments(_ post: Post)
}

class HomePostCell: BaseCollectionViewCell {
    
    weak var delegate: HomePostCellDelegate?
    
    static let reuseIdentifier = "HomePostCellReuseId"
    var post: Post? {
        didSet {
            guard let post = post else { return }
            setupCellWithPost(post)
            setupCellWithUser(post.user)
            setupLikeButton()
            setupLikersLabel()
            setupViewCommentsButton()
            showViewCommentsWithCount(count: post.comments.count)
        }
    }
    
    let postProfileImageView: UIImageView = UIImageView(image: nil, contentMode: .scaleAspectFill)
    let postUsernameLabel: UILabel = UILabel(text: "7amada", font: UIFont.boldSystemFont(ofSize: 13), color: .black)
    lazy var settingsButton = UIButton.systemButton(image: #imageLiteral(resourceName: "more"), target: self, selector: #selector(handleSettingsTapped))
    
    lazy var likeButton = UIButton.systemButton(image: #imageLiteral(resourceName: "like_unselected"), tintColor: .black, target: self, selector: #selector(handleLikeTapped))
    lazy var commentButton = UIButton.systemButton(image: #imageLiteral(resourceName: "comment"), target: self, selector: #selector(handleCommentTapped))
    lazy var sendDmButton = UIButton.systemButton(image: #imageLiteral(resourceName: "dm"),  target: self, selector: #selector(handleSendDmTapped))
    lazy var bookmarkButton = UIButton.systemButton(image: #imageLiteral(resourceName: "bookmark"), target: self, selector: #selector(handleBookmarkTapped))
    
    let postImageView = UIImageView(image: nil, contentMode: .scaleAspectFill, userInteraction: true)
    
    let likeCommentContainer = UIView()
    let likersLabel = UILabel(text: "7amada", font: UIFont.boldSystemFont(ofSize: 13), color: .black)
    let captionButton = UIButton.systemButton(titleColor: .black, font: UIFont.boldSystemFont(ofSize: 13), target: self, selector: #selector(handleCaption))
    let dateLabel = UILabel(text: "", font: UIFont.systemFont(ofSize: 13), color: .lightGray)
    lazy var viewCommentsButton = UIButton.systemButton(titleColor: .lightGray, font: UIFont.boldSystemFont(ofSize: 14), target: self, selector: #selector(handleViewComments))
    lazy var likeCommentDmStackView = UIStackView(axis: .horizontal, alignment: .fill, distribution: .equalSpacing, arrangedSubviews: [likeButton, commentButton, sendDmButton])
    
    lazy var profileDetailsContainer: UIView = {
        let view = UIView()
        view.addSubviews(postProfileImageView, postUsernameLabel, settingsButton)
        self.postProfileImageView.anchor(left: view.leftAnchor, leftConstant: 6, widthConstant: 30, heightConstant: 30, centerYInSuperView: true)
        self.postProfileImageView.roundCircular(width: 30)
        self.postUsernameLabel.anchor(left: self.postProfileImageView.rightAnchor, leftConstant: 4, widthConstant: 100, heightConstant: 20, centerYInSuperView: true)
        self.settingsButton.anchor(right: view.rightAnchor, rightConstant: 7, widthConstant: 25, heightConstant: 25, centerYInSuperView: true)
        return view
    }()
    
    lazy var likeCommentDmContainer: UIView = {
        let view = UIView()
        view.addSubviews(likeCommentDmStackView, bookmarkButton)
        likeCommentDmStackView.anchor(left: view.leftAnchor, leftConstant: 10, widthConstant: 105, heightConstant: 35, centerYInSuperView: true)
        bookmarkButton.anchor(right: view.rightAnchor, rightConstant: 7, widthConstant: 25, heightConstant: 25, centerYInSuperView: true)
        return view
    }()
    
    @objc func handleCaption() {

    }
    
    override func setupViews() {
        super.setupViews()
        self.backgroundColor = .white
        setupProfileDetailsContainer()
        setupPostImageView()
        setupLikeCommentDmContainer()
        setupLikersContainer()
        setupCaptionContainer()
        setupViewCommentsButton()
        setupDateLabel()
        setupButtonTapAreas()
    }

    private func setupButtonTapAreas() {
        likeButton.anchor(widthConstant: 35, heightConstant: 35)
        commentButton.anchor(widthConstant: 35, heightConstant: 35)
        sendDmButton.anchor(widthConstant: 35, heightConstant: 35)
        likeButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: -(35/2), bottom: 0, right: 0)
        commentButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: -(35/2), bottom: 0, right: 0)
        sendDmButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: -(35/2), bottom: 0, right: 0)
    }

    private func setupProfileDetailsContainer() {
        self.addSubview(profileDetailsContainer)
        profileDetailsContainer.anchor(self.topAnchor, left: self.leftAnchor, right: self.rightAnchor, heightConstant: 50)
        postProfileImageView.backgroundColor = .lightGray
    }
    
    private func setupLikeCommentDmContainer() {
        self.addSubview(likeCommentDmContainer)
        likeCommentDmContainer.anchor( postImageView.bottomAnchor, left: self.leftAnchor, right: self.rightAnchor, topConstant: 10, heightConstant: 25)
    }

    private func setupPostImageView() {
        self.addSubview(postImageView)
        postImageView.anchor(profileDetailsContainer.bottomAnchor, left: self.leftAnchor, right: self.rightAnchor, heightConstant: 400)
        postImageView.backgroundColor = .lightGray
    }
    
    private func setupLikersContainer() {
        self.addSubview(likersLabel)
        likersLabel.anchor(likeCommentDmContainer.bottomAnchor, left: self.leftAnchor, right: self.rightAnchor, topConstant: 0, leftConstant: 10, rightConstant: 10, heightConstant: 25)
    }
    
    private func setupCaptionContainer() {
        self.addSubview(captionButton)
        captionButton.anchor(likersLabel.bottomAnchor, left: self.leftAnchor, right: self.rightAnchor, topConstant: 0, leftConstant: 10, rightConstant: 10, heightConstant: 20)
        captionButton.contentHorizontalAlignment = .left
        captionButton.setTitleColor(.black, for: .normal)
    }
    
    private func setupViewCommentsButton() {
        viewCommentsButton.isHidden = true
        self.addSubview(viewCommentsButton)
         viewCommentsButton.anchor(captionButton.bottomAnchor, left: self.leftAnchor, right: self.rightAnchor, topConstant: 0, leftConstant: 10, rightConstant: 10, heightConstant: 20)
        viewCommentsButton.contentHorizontalAlignment = .left
    }
    private func showViewCommentsWithCount(count: Int) {
        if count == 1 {
            viewCommentsButton.setTitle("View \(count) comment", for: .normal)
            showViewCommentsButton()
        } else if count > 1 {
            showViewCommentsButton()
            viewCommentsButton.setTitle("View all \(count) comment", for: .normal)
        } else {
            hideViewCommentsButton()
        }
    }
    
    func showViewCommentsButton() {
        viewCommentsButton.isHidden = false
        dateLabelModifyConstraints()
    }
    func hideViewCommentsButton() {
        viewCommentsButton.isHidden = true
        dateLabelModifyConstraints()
    }
    var dateLabelTopConstraint: NSLayoutConstraint?
    private func setupDateLabel() {
        self.addSubview(dateLabel)
        dateLabel.anchor(left: self.leftAnchor, right: self.rightAnchor, leftConstant: 10, rightConstant: 10, heightConstant: 20)
        dateLabelModifyConstraints()
    }
    private func dateLabelModifyConstraints() {
        if viewCommentsButton.isHidden {
            dateLabelTopConstraint?.isActive = false
            dateLabelTopConstraint = dateLabel.topAnchor.constraint(equalTo: captionButton.bottomAnchor, constant: 3)
            dateLabelTopConstraint?.isActive = true
        } else {
            dateLabelTopConstraint?.isActive = false
            dateLabelTopConstraint = dateLabel.topAnchor.constraint(equalTo: viewCommentsButton.bottomAnchor, constant: 3)
            dateLabelTopConstraint?.isActive = true
        }
    }

    private func setupCellWithUser(_ user: User) {
        self.postUsernameLabel.text = user.username
        guard let profImageUrl = URL(string: user.profileImageUrl ?? "") else { return }
        self.postProfileImageView.kf.setImage(with: profImageUrl)
    }

    private func setupCellWithPost(_ post: Post) {
        guard let postUrl = URL(string: post.postUrl ?? "") else { return }
        let user = post.user
        postImageView.kf.setImage(with: postUrl)
        let captionText = NSMutableAttributedString(string: "\(user.username ?? "") ", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        captionText.append(NSAttributedString(string: post.caption ?? "", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13), NSAttributedString.Key.foregroundColor: UIColor.black]))
        self.captionButton.setAttributedTitle(captionText, for: .normal)
        dateLabel.text = (post.creationDate).timeAgoAlgorithm(format: "MMM d, yyyy")
    }

    private func setupLikeButton() {
        guard let liked = post?.isLiked else { return }
        likeButton.tintColor = liked ? UIColor(hex: 0xe73146) : .black
        likeButton.setImage(liked ? #imageLiteral(resourceName: "like_selected") : #imageLiteral(resourceName: "like_unselected"), for: .normal)
    }

    private func setupLikersLabel() {
        guard let likersCount = post?.likersUids.count else { return }
        if likersCount == 0 {
            likersLabel.text = "0 Likes"
        } else if post?.likersUids.count == 1 {
            likersLabel.text = "\(likersCount) Like"
        } else {
            likersLabel.text = "\(likersCount) Likes"
        }
    }

    @objc func handleLikeTapped(for cell: HomePostCell) {
        delegate?.didTapLike(for: self)
    }
    @objc func handleCommentTapped() {
        guard let post = self.post else { return }
        delegate?.didTapCommentWithPost(post)
    }
    @objc func handleBookmarkTapped() {
        delegate?.didTapBookmark()
    }
    @objc func handleSettingsTapped() {
        delegate?.didTapSettings()
    }
    @objc func handleSendDmTapped() {
        delegate?.didTapSendDm()
    }
    @objc func handleViewComments() {
        guard let post = self.post else { return }
        delegate?.didTapViewComments(post)
    }
}
