//
//  CommentsController.swift
//  InstagramClone
//
//  Created by Ahmed Amr on 5/20/20.
//  Copyright © 2020 Ahmed Amr. All rights reserved.
//

import UIKit
import Firebase
class CommentsController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    var postId: String?
    var comments = [Comment]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .red
        containerView.delegate = self
        navigationItem.title = "Comments"
        setupCollectionView()
        fetchComments()
    }
    
    private func fetchComments() {
        guard let postId = postId else { return }
        FirebaseHelper.observeCommentsWithPostId(postId, completionHandler: { (comment) in
            guard let comment  = comment else { return }
            self.comments.insert(comment, at: 0)
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }) { (errMessage) in
            print(errMessage)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comments.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CommentCell.reuseId, for: indexPath) as? CommentCell else { return UICollectionViewCell() }
        cell.comment = comments[indexPath.row]
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let text = "\(String(describing: comments[indexPath.row].user.username)) \(comments[indexPath.item].text)"
        let height = Int(estimateFrameForText(text: text, font: UIFont.systemFont(ofSize: 15)).height) + 30
        return CGSize(width: view.frame.width, height: CGFloat(max(50, height)))
    }

    func estimateFrameForText(text: String, font: UIFont) -> CGRect {
        let size = CGSize(width: view.frame.width - 46, height: view.frame.height)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: font], context: nil)
    }
    
    private func setupCollectionView() {
        collectionView.backgroundColor = .white
        collectionView.register(CommentCell.self, forCellWithReuseIdentifier: CommentCell.reuseId)
        collectionView.alwaysBounceVertical = true
        collectionView.keyboardDismissMode = .interactive
    }

    lazy var containerView: CommentInputAccessoryView = {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 100)
        let commentInputAccessoryView = CommentInputAccessoryView(frame: frame)
        return commentInputAccessoryView
    }()

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.async {
        self.containerView.commentTextView.becomeFirstResponder()
        }
    }

    override var inputAccessoryView: UIView? {
        get {
            return containerView
        }
    }
    override var canBecomeFirstResponder: Bool {
           return true
       }
}
extension CommentsController: CommentInputAccessoryDelegate {
    func didTapPost(text: String) {
        guard let postId = postId else { return }
        guard let currentUserUid = FirebaseHelper.currentUserUid else { return }
        let values = ["text": text, "uid": currentUserUid, "timeStamp": Date().timeIntervalSince1970] as [String : Any]
        FirebaseHelper.commentsDatabase.child(postId).childByAutoId().updateChildValues(values) { (err, ref) in
            if let err = err {
                print("Failed to save comment: ", err)
                return
            }
            print("Saved Comment Successfully")
        }
    }
}
