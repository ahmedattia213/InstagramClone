//
//  CommentInputAccessoryView.swift
//  InstagramClone
//
//  Created by Ahmed Amr on 5/21/20.
//  Copyright © 2020 Ahmed Amr. All rights reserved.
//

import UIKit

protocol CommentInputAccessoryDelegate: class {
    func didTapPost(text: String)
}
class CommentInputAccessoryView: UIView, UITextViewDelegate {
    weak var delegate: CommentInputAccessoryDelegate?
    
    let defaultCommentMessage = "Add a comment..."
    let defaultCommentFont = UIFont.systemFont(ofSize: 14)
    let editedCommentFont = UIFont.systemFont(ofSize: 16)
    
    let enabledPostButtonColor = UIColor(hex: 0x1676f6)
    let disablePostButtonColor = UIColor(hex: 0xb2d0f0)
    
    lazy var commentTextView: UITextView = {
        let textView = UITextView(text: defaultCommentMessage, font: defaultCommentFont, color: .lightGray)
        textView.delegate = self
        textView.isScrollEnabled = false
        return textView
    }()
    lazy var commentTextViewContainer: UIView = {
        let view = UIView(color: .clear)
        view.layer.borderColor = UIColor(hex: 0xc9c9c9).cgColor
        view.layer.borderWidth = 1
        view.clipsToBounds = true
        view.layer.cornerRadius = 15
        
        return view
    }()
    
    lazy var commentViewContainer: UIView = {
        let view = UIView(color: .clear)
        
        return view
    }()
    
    let profileImageView = UIImageView(contentMode: .scaleAspectFill)
    
    lazy var postCommentButton: UIButton = UIButton.systemButton(title: "Post", titleColor: disablePostButtonColor, font: UIFont.systemFont(ofSize: 16), target: self, selector: #selector(handlePostComment))
    
    
    
    lazy var emojiView = UIStackView(axis: .horizontal, alignment: .fill, distribution: .fillEqually, spacing: 4, arrangedSubviews: [heartEmoji, kissEmoji, hundredEmoji, fireEmoji, winkEmoji, smilingEmoji, arrowHeartEmoji, smilingFaceEyesEmoji])

    let heartEmoji: UIButton = {
        let button = UIButton.systemButton(title: "❤️", font: UIFont.systemFont(ofSize: 19), target: self, selector: #selector(handleEmoji))
        button.tag = 1
        return button
    }()
    let kissEmoji: UIButton = {
        let button = UIButton.systemButton(title: "😘", font: UIFont.systemFont(ofSize: 19), target: self, selector: #selector(handleEmoji))
        button.tag = 2
        return button
    }()
    let hundredEmoji: UIButton = {
        let button = UIButton.systemButton(title: "💯", font: UIFont.systemFont(ofSize: 19), target: self, selector: #selector(handleEmoji))
        button.tag = 3
        return button
    }()
    let fireEmoji: UIButton = {
        let button = UIButton.systemButton(title: "🔥", font: UIFont.systemFont(ofSize: 19), target: self, selector: #selector(handleEmoji))
        button.tag = 4
        return button
    }()
    let winkEmoji: UIButton = {
        let button = UIButton.systemButton(title: "😉", font: UIFont.systemFont(ofSize: 19), target: self, selector: #selector(handleEmoji))
        button.tag = 5
        return button
    }()
    let smilingEmoji: UIButton = {
        let button = UIButton.systemButton(title: "☺️", font: UIFont.systemFont(ofSize: 19), target: self, selector: #selector(handleEmoji))
        button.tag = 6
        return button
    }()
    let arrowHeartEmoji: UIButton = {
        let button = UIButton.systemButton(title: "💘", font: UIFont.systemFont(ofSize: 19), target: self, selector: #selector(handleEmoji))
        button.tag = 7
        return button
    }()
    let smilingFaceEyesEmoji: UIButton = {
        let button = UIButton.systemButton(title: "😊", font: UIFont.systemFont(ofSize: 19), target: self, selector: #selector(handleEmoji))
        button.tag = 8
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        autoresizingMask = .flexibleHeight
        backgroundColor = .white
        emojiView.backgroundColor = .white
        setupUI()
 
    }

    private func setupUI() {
        setupSubviews()
        setupCommentViewContainerSubviews()
        setupCommentTextViewContainerSubviews()
        profileImageView.backgroundColor = .purple
        profileImageView.roundCircular(width: 40)
        profileImageView.backgroundColor = .lightGray

    }
    
    private func setupSubviews() {
        addSubviews(emojiView, commentViewContainer)
        emojiView.anchor(topAnchor, left: leftAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, rightConstant: 0, heightConstant: 50)
        commentViewContainer.anchor(emojiView.bottomAnchor, left: leftAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, right: rightAnchor)
    }
    
    private func setupCommentTextViewContainerSubviews() {
        commentTextViewContainer.addSubviews(commentTextView, postCommentButton)
        postCommentButton.anchor(bottom: commentTextViewContainer.bottomAnchor, right: commentTextViewContainer.rightAnchor, bottomConstant: 2, rightConstant: 8, widthConstant: 40, heightConstant: 40)
        commentTextView.anchor(commentTextViewContainer.topAnchor, left: commentTextViewContainer.leftAnchor, bottom: commentTextViewContainer.bottomAnchor, right: postCommentButton.leftAnchor, topConstant: 2, leftConstant: 2, bottomConstant: 2, rightConstant: 2)
    }
    
    private func setupCommentViewContainerSubviews() {
        commentViewContainer.addSubviews(profileImageView,commentTextViewContainer)
        profileImageView.anchor(left: commentViewContainer.leftAnchor, bottom: commentViewContainer.bottomAnchor, leftConstant: 8, bottomConstant: 3, widthConstant: 40, heightConstant: 40)
        commentTextViewContainer.anchor(commentViewContainer.topAnchor, left: profileImageView.rightAnchor, bottom: commentViewContainer.bottomAnchor, right: commentViewContainer.rightAnchor, topConstant: 3, leftConstant: 8, bottomConstant: 8, rightConstant: 8)
    }

    override var intrinsicContentSize: CGSize {
        return .zero
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        handleCommentTextViewEdited()
        textView.becomeFirstResponder()
    }

    func handleCommentTextViewEdited() {
        if  commentTextView.text == defaultCommentMessage && commentTextView.textColor == .lightGray {
            commentTextView.text = ""
            commentTextView.textColor = .black
            commentTextView.font = editedCommentFont
        }
    }

    func textViewDidChange(_ textView: UITextView) {
        let notAllowedtext = CharacterSet.init(charactersIn: " ")
        let writtenString = textView.text!
        let writtenText = CharacterSet.init(charactersIn: writtenString)
        if !(writtenString == defaultCommentMessage || writtenString == "" || notAllowedtext.isSuperset(of: writtenText)) {
            enablePostCommentButton()
        } else {
            disablePostCommentButton()
            textView.text = ""
            textView.textColor = .black
            textView.font = editedCommentFont
        }
    }

    private func disablePostCommentButton() {
        postCommentButton.isUserInteractionEnabled = false
        postCommentButton.setTitleColor(disablePostButtonColor, for: .normal)
    }

    private func enablePostCommentButton() {
        postCommentButton.isUserInteractionEnabled = true
        postCommentButton.setTitleColor(enabledPostButtonColor, for: .normal)
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        textView.font = defaultCommentFont
        textView.text = defaultCommentMessage
        textView.textColor = .lightGray
        textView.resignFirstResponder()
    }

    @objc func handlePostComment() {
        delegate?.didTapPost(text: commentTextView.text)
    }
    
    @objc func handleEmoji(sender: UIButton) {
        handleCommentTextViewEdited()
        enablePostCommentButton()
        switch sender.tag {
        case 1: commentTextView.text += "❤️"
        case 2: commentTextView.text += "😘"
        case 3: commentTextView.text += "💯"
        case 4: commentTextView.text += "🔥"
        case 5: commentTextView.text += "😉"
        case 6: commentTextView.text += "☺️"
        case 7: commentTextView.text += "💘"
        case 8: commentTextView.text += "😊"
        default:
            break
        }
    }
}
