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
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupCollectionView()
    }
    
    private func setupNavBar() {
        navigationItem.title = "Posts"
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
        //fetchMyPosts
    }
    private func fetchAllPosts() {
        posts.removeAll()
        fetchMyPosts()
    }
    private func fetchMyPosts() {
        
    }
    private func observePosts() {
        guard let uid = FirebaseHelper.currentUserUid else { return }
        FirebaseHelper.fetchUserWithUid(uid) { (user) in
            self.fetchPostsAndAppend(user)
        }
    }
    private func fetchPostsAndAppend(_ user: User) {
        FirebaseHelper.observePostsWithUid(user, completionHandler: { (newPost) in
            if let newPost = newPost {
                if !self.posts.contains(where: {$0.key == newPost.key}) {
                    self.posts.insert(newPost, at: 0)
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
    func didTapSettings() {
            
    }
    
    func didTapSendDm() {
            
    }
    
    func didTapBookmark() {
            
    }
    
    func didTapCommentWithPost(_ post: Post) {
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
