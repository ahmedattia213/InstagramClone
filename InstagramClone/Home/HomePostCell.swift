//
//  HomePostCell.swift
//  InstagramClone
//
//  Created by Ahmed Amr on 9/30/19.
//  Copyright © 2019 Ahmed Amr. All rights reserved.
//

import UIKit
import SVProgressHUD

class HomePostCell: BaseCollectionViewCell {

    static let reuseIdentifier = "HomePostCellReuseId"
    var post: Post? {
        didSet {
            setupCellWithPost(post!)
        }
    }

    var user: User? {
        didSet {
            setupCellWithUser(user!)
        }
    }

    let postProfileImageView: UIImageView = UIImageView(image: nil, contentMode: .scaleAspectFill)
    let postUsernameLabel: UILabel = UILabel(text: "7amada", font: UIFont.boldSystemFont(ofSize: 13), color: .black)
    let settingsImageView: UIImageView = UIImageView(image: #imageLiteral(resourceName: "more"), contentMode: .scaleAspectFit, tintColour: nil, userInteraction: true)
    let bookmarkImageView: UIImageView = UIImageView(image: #imageLiteral(resourceName: "bookmark"), contentMode: .scaleAspectFit, tintColour: nil, userInteraction: true)

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
        view.addSubviews(likeCommentDmStackView, bookmarkImageView)
        likeCommentDmStackView.anchor(left: view.leftAnchor, leftConstant: 10, widthConstant: 150, heightConstant: 25, centerYInSuperView: true)
        bookmarkImageView.anchor(right: view.rightAnchor, rightConstant: 7, widthConstant: 25, heightConstant: 25, centerYInSuperView: true)

        return view
    }()

    let postImageView = UIImageView(image: nil, contentMode: .scaleAspectFill, userInteraction: true)

    let likeCommentContainer = UIView()
    let size = CGSize(width: 32, height: 32)
    let likeImageView = UIImageView(image: #imageLiteral(resourceName: "like_unselected"), contentMode: .scaleAspectFit, tintColour: nil, userInteraction: true)
    let commentImageView = UIImageView(image: #imageLiteral(resourceName: "comment"), contentMode: .scaleAspectFit, tintColour: nil, userInteraction: true)
    let dmImageView = UIImageView(image: #imageLiteral(resourceName: "dm"), contentMode: .scaleAspectFit, tintColour: nil, userInteraction: true)

    lazy var likeCommentDmStackView = UIStackView(axis: .horizontal, alignment: .fill, distribution: .fillEqually, spacing: 20, arrangedSubviews: [likeImageView, commentImageView, dmImageView])

    let likersLabel = UILabel(text: "7amada", font: UIFont.boldSystemFont(ofSize: 13), color: .black)

    let captionButton = UIButton.systemButton(titleColor: .black, font: UIFont.boldSystemFont(ofSize: 13), target: self, selector: #selector(handleCaption))

    let dateLabel = UILabel(text: "1 week ago", font: UIFont.systemFont(ofSize: 13), color: .lightGray)
    
    @objc func handleCaption() {
        print("HEY THERE")
    }
    
  
    override func setupViews() {
        super.setupViews()
        self.backgroundColor = .white
        setupProfileDetailsContainer()
        setupPostImageView()
        setupLikeCommentDmContainer()
        setupLikersContainer()
        setupCaptionContainer()
        setupDateLabel()
        setupTaps()
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
    }

    private func setupLikeCommentDmContainer() {
        self.addSubview(likeCommentDmContainer)
        likeCommentDmContainer.anchor( postImageView.bottomAnchor, left: self.leftAnchor, right: self.rightAnchor, topConstant: 10, heightConstant: 50)
    }

    private func setupPostImageView() {
        self.addSubview(postImageView)
        postImageView.anchor(profileDetailsContainer.bottomAnchor, left: self.leftAnchor, right: self.rightAnchor, heightConstant: 400)
        postImageView.backgroundColor = .lightGray
    }

    private func setupLikersContainer() {
        self.addSubview(likersLabel)
        likersLabel.anchor(likeCommentDmContainer.bottomAnchor, left: self.leftAnchor, right: self.rightAnchor, topConstant: 0, leftConstant: 10, rightConstant: 10, heightConstant: 25)
        likersLabel.text = "75 Likes"
    }

    private func setupCaptionContainer() {
        self.addSubview(captionButton)
       captionButton.anchor(likersLabel.bottomAnchor, left: self.leftAnchor, right: self.rightAnchor, topConstant: 0, leftConstant: 10, rightConstant: 10, heightConstant: 20)

        captionButton.contentHorizontalAlignment = .left
        captionButton.setTitleColor(.black, for: .normal)
    }

    private func setupDateLabel() {
        self.addSubview(dateLabel)
        dateLabel.anchor(captionButton.bottomAnchor, left: self.leftAnchor, right: self.rightAnchor, topConstant: 0, leftConstant: 10, rightConstant: 10, heightConstant: 20)
    }

    @objc func tozfeky() {
        SVProgressHUD.showSuccess(withStatus: "Toz feeky")
        SVProgressHUD.dismiss(withDelay: 0.5)
    }

    private func setupCellWithUser(_ user: User) {
        print(user)
        self.postUsernameLabel.text = user.username
        guard let profImageUrl = URL(string: user.profileImageUrl ?? "") else { return }
        self.postProfileImageView.kf.setImage(with: profImageUrl)
    }

    private func setupCellWithPost(_ post: Post) {
        guard let postUrl = URL(string: post.postUrl ?? "") else { return }
        guard let user = self.user else { return }
        postImageView.kf.setImage(with: postUrl)
        let captionText = NSMutableAttributedString(string: "\(user.username ?? "") ", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        captionText.append(NSAttributedString(string: post.caption ?? "", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13), NSAttributedString.Key.foregroundColor: UIColor.black]))
        self.captionButton.setAttributedTitle(captionText, for: .normal)
    }

    private func setupTaps() {
          let gest = UITapGestureRecognizer(target: self, action: #selector(tozfeky))
          let gest1 = UITapGestureRecognizer(target: self, action: #selector(tozfeky))
          let gest2 = UITapGestureRecognizer(target: self, action: #selector(tozfeky))
          let gest3 = UITapGestureRecognizer(target: self, action: #selector(tozfeky))
          let gest4 = UITapGestureRecognizer(target: self, action: #selector(tozfeky))
          settingsImageView.addGestureRecognizer(gest)
          likeImageView.addGestureRecognizer(gest1)
          commentImageView.addGestureRecognizer(gest2)
          dmImageView.addGestureRecognizer(gest3)
          bookmarkImageView.addGestureRecognizer(gest4)
      }
}
