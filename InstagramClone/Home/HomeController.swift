//
//  HomeController.swift
//  InstagramClone
//
//  Created by Ahmed Amr on 9/30/19.
//  Copyright © 2019 Ahmed Amr. All rights reserved.
//

import UIKit
import FirebaseAuth

class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    var posts = [Post]() {
        didSet {
            posts.sort(by: { $0.creationDate ?? Date() > $1.creationDate ?? Date() })
        }
    }

    var user: User?

    override func viewDidLoad() {
        fetchCurrentUser()
        setupNavBar()
        setupCollectionView()
        fetchAllPosts()
        setupSwipeGestureRecognizer()
    }

    private func setupSwipeGestureRecognizer() {
        let swipeRightGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleOpenCamera))
        swipeRightGesture.direction = .right
        self.view.addGestureRecognizer(swipeRightGesture)
    }

    private func setupNavBar() {
        navigationController?.navigationBar.barTintColor = .background
        let logoColour = UIColor(redValue: 18, greenValue: 18, blueValue: 18, alphaValue: 1)
        let imageView = UIImageView(image: #imageLiteral(resourceName: "Instagram_logo_white"), contentMode: .scaleAspectFit, tintColour: logoColour)
        navigationItem.titleView = imageView
        let dmBarButton = UIBarButtonItem(image: #imageLiteral(resourceName: "dm"), style: .plain, target: self, action: #selector(handleOpenDm))
        let cameraBarButton = UIBarButtonItem(image: #imageLiteral(resourceName: "camera"), style: .plain, target: self, action: #selector(handleOpenCamera))
        navigationItem.rightBarButtonItem = dmBarButton
        navigationItem.leftBarButtonItem = cameraBarButton
    }

    @objc private func handleOpenDm() {
        print("Open direct messages")
    }

    @objc private func handleOpenCamera() {
        let cameraController = CameraController()
        cameraController.modalPresentationStyle = .fullScreen
        self.present(cameraController, animated: true, completion: nil)
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

    private func observePosts() {
        guard let uid = FirebaseHelper.currentUserUid else { return }
        FirebaseHelper.fetchUserWithUid(uid) { (user) in
            self.fetchPostsAndAppend(user)
        }
    }

    private func fetchFollowingPosts() {
        guard let currentUserUid = Auth.auth().currentUser?.uid else { return }
        let ref = FirebaseHelper.usersFollowing.child(currentUserUid)
        ref.observe(.childAdded) { (snapshot) in
                FirebaseHelper.fetchUserWithUid(snapshot.key) { (user) in
                    self.fetchPostsAndAppend(user)
                }
        }
    }

    private func fetchCurrentUser() {
        guard let uid = FirebaseHelper.currentUserUid else { return }
        FirebaseHelper.fetchUserWithUid(uid) { (user) in
            self.user = user
            self.collectionView.reloadData()
        }
    }

    lazy var refreshControl: UIRefreshControl = {
       let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        return refreshControl
    }()

    @objc func handleRefresh() {
        fetchAllPosts()
    }

    private func fetchAllPosts() {
        observePosts()
        fetchFollowingPosts()
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
}

extension HomeController: HomePostCellDelegate {
    func didTapCommentWithPost(_ post: Post) {
        let commentsController = CommentsController(collectionViewLayout: UICollectionViewFlowLayout())
        commentsController.postId = post.key
        commentsController.hidesBottomBarWhenPushed = true   //best solution to hide tabbar
        navigationController?.pushViewController(commentsController, animated: true)
    }

    func didTapSettings() {
        print("settings tapped")
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

    func didTapSendDm() {
        print("send dm tapped")
    }

    func didTapBookmark() {
        print("bookmark tapped")
    }
}
