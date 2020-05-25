//
//  UserFeedController.swift
//  InstagramClone
//
//  Created by Ahmed Amr on 5/25/20.
//  Copyright © 2020 Ahmed Amr. All rights reserved.
//

import UIKit

class UserFeedController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    var posts = [Post]()
    var user: User?
    var indexPath: IndexPath? {
        didSet {
            collectionView.scrollToItem(at: indexPath ?? IndexPath(item: 0, section: 0), at: .top, animated: false)
            collectionView.layoutIfNeeded()
        }
    }
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        return refreshControl
    }()
    var postComments = [String: [Comment]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupCollectionView()
    }
    
    private func setupNavBar() {
        navigationItem.title = "Posts"
    }
    private func fetchComments(for post: Post?) {
        guard let passedPost = post else { return }
        guard let postId = passedPost.key else { return }
        var newPost = passedPost
        FirebaseHelper.observeCommentsWithPostId(postId, completionHandler: { (comment) in
            guard let comment  = comment else { return }
            var commentsArray = [Comment]()
            if self.postComments[postId] != nil {
                commentsArray = self.postComments[postId]!
            }
            if !(commentsArray.contains(where: {$0.key == comment.key})) {
                commentsArray.append(comment)
                print(comment.text, "   dakhl")
            }
            if self.postComments[postId] != nil {
                self.postComments.updateValue(commentsArray, forKey: postId)
            } else {
                self.postComments[postId] = commentsArray
            }
            
            print(commentsArray, "   " , comment.text , "    MA AHO")
            newPost.comments = commentsArray
            if let index = self.posts.firstIndex(of: passedPost) {
                self.posts[index] = newPost
            }
            self.collectionView.reloadData()
        }) { (errMessage) in
            print(errMessage)
        }
    }
    private func setupCollectionView() {
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .white
        collectionView.register(HomePostCell.self, forCellWithReuseIdentifier: HomePostCell.reuseIdentifier)
        collectionView.refreshControl = refreshControl
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomePostCell.reuseIdentifier, for: indexPath) as? HomePostCell else { return UICollectionViewCell() }
        cell.post = posts[indexPath.row]
        cell.delegate = self
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 560)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 7
    }
    @objc func handleRefresh() {
        fetchUsersPosts()
    }
    private func fetchUsersPosts() {
        observePosts()
    }
    private func observePosts() {
        guard let uid = user?.uid else { return }
        FirebaseHelper.fetchUserWithUid(uid) { (user) in
            self.fetchPostsAndAppend(user)
        }
    }
    private func fetchPostsAndAppend(_ user: User) {
        FirebaseHelper.observePostsWithUid(user, completionHandler: { (newPost) in
            if let newPost = newPost {
                if !self.posts.contains(where: {$0.key == newPost.key}) {
                    self.posts.insert(newPost, at: 0)
                    self.fetchComments(for: newPost)
                    self.collectionView.reloadData()
                }
            }
            self.collectionView.refreshControl?.endRefreshing()
        }) { (err) in
            if let err = err {
                print(err)
            }
        }
    }
}
extension UserFeedController: HomePostCellDelegate {
    func didTapViewComments(_ post: Post) {
        showCommentsControllerForPost(post)
    }
    func didTapSettings() {
        
    }
    
    func didTapSendDm() {
        
    }
    
    func didTapBookmark() {
        
    }
    
    func didTapCommentWithPost(_ post: Post) {
        showCommentsControllerForPost(post)
    }
    
    func showCommentsControllerForPost(_ post: Post) {
        let commentsController = CommentsController(collectionViewLayout: UICollectionViewFlowLayout())
        commentsController.postId = post.key
        commentsController.hidesBottomBarWhenPushed = true   //best solution to hide tabbar
        navigationController?.pushViewController(commentsController, animated: true)
    }
    func didTapLike(for cell: HomePostCell) {
        print("like tapped")
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        var post = self.posts[indexPath.row]
        guard let postId = post.key else { return }
        guard let currentUserUid = FirebaseHelper.currentUserUid else { return }
        let values = [currentUserUid: !post.isLiked]
        FirebaseHelper.likesDatabase.child(postId).updateChildValues(values) { (err, ref) in
            if let err = err {
                print("Failed to save like: ", err)
                return
            }
            print("Liked successfully")
            post.isLiked = !post.isLiked
            self.posts[indexPath.row] = post
            self.collectionView.reloadItems(at: [indexPath])
        }
    }
}
