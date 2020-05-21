//
//  CommentsController.swift
//  InstagramClone
//
//  Created by Ahmed Amr on 5/20/20.
//  Copyright © 2020 Ahmed Amr. All rights reserved.
//

import UIKit

class CommentsController: UICollectionViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .red
        containerView.delegate = self
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
        print("HI COMMENT is ", text)
    }
 
}
