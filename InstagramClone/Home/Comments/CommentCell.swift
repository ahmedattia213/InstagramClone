//
//  CommentCell.swift
//  InstagramClone
//
//  Created by Ahmed Amr on 5/21/20.
//  Copyright © 2020 Ahmed Amr. All rights reserved.
//

import UIKit

class CommentCell: UICollectionViewCell {
    static let reuseId = "CommentCellReuseIdentifier"
    let profileImageView = UIImageView(image: nil, contentMode: .scaleAspectFill, cornerRadius: 20, userInteraction: true)
    let textView = UITextView(text: "Hi ezayak el soora to7fa", font: UIFont.systemFont(ofSize: 13), color: .black, isEditable: false)
    let dateLabel = UILabel(text: "30m", font: UIFont.systemFont(ofSize: 13), color: .lightGray)
    lazy var likeButton = UIButton.systemButton(image: #imageLiteral(resourceName: "like_unselected"), tintColor: .black, target: self, selector: #selector(handleCommentLike))
    let likesLabel = UILabel(text: "30m", font: UIFont.systemFont(ofSize: 13), color: .lightGray)

    var comment: Comment? {
        didSet {
            guard let comment = comment else { return }
            setupCellWithCommentAndUser(comment, comment.user)
        }
    }
    
    private func setupCellWithCommentAndUser(_ comment: Comment, _ user: User) {
        guard let profImageUrl = URL(string: user.profileImageUrl ?? "") else { return }
        profileImageView.kf.setImage(with: profImageUrl)
        let commentText = NSMutableAttributedString(string: "\(user.username ?? "") ", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15)])
            commentText.append(NSAttributedString(string: comment.text, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15), NSAttributedString.Key.foregroundColor: UIColor.black]))
        textView.attributedText = commentText
        dateLabel.text = comment.timeStamp.timeAgoAlgorithm(format: "MMM d, yyyy")
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        textView.isScrollEnabled = false
        profileImageView.backgroundColor = .lightGray
        addSubviews(profileImageView, textView, dateLabel)
        profileImageView.anchor(topAnchor, left: leftAnchor, topConstant: 3, leftConstant: 3,  widthConstant: 40, heightConstant: 40)
        textView.anchor(topAnchor, left: profileImageView.rightAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 3, leftConstant: 3, bottomConstant: 20, rightConstant: 3)
        dateLabel.anchor(textView.bottomAnchor, left: textView.leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 2, leftConstant: 3)
        
//        let captionText = NSMutableAttributedString(string: "\(user.username ?? "") ", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
//            captionText.append(NSAttributedString(string: post.caption ?? "", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13), NSAttributedString.Key.foregroundColor: UIColor.black]))
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func handleCommentLike() {
        
    }
}
