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
        observePosts()
        fetchFollowingPosts()
    }
    
    private func setupNavBar() {
        navigationController?.navigationBar.barTintColor = .background
        let logoColour = UIColor(redValue: 18, greenValue: 18, blueValue: 18, alphaValue: 1)
        let imageView = UIImageView(image: #imageLiteral(resourceName: "Instagram_logo_white"), contentMode: .scaleAspectFit, tintColour: logoColour)
        navigationItem.titleView = imageView
    }
    
    private func fetchPostsAndAppend(_ user: User) {
        FirebaseHelper.observePostsWithUid(user, completionHandler: { (newPost) in
            if let newPost = newPost {
                self.posts.insert(newPost, at: 0)
                self.collectionView.reloadData()
            }
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
    
    fileprivate func fetchFollowingPosts() {
        guard let currentUserUid = Auth.auth().currentUser?.uid else { return }
        print(currentUserUid, "   CURENT")
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
    
    private func setupCollectionView() {
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .white
        collectionView.register(HomePostCell.self, forCellWithReuseIdentifier: HomePostCell.reuseIdentifier)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomePostCell.reuseIdentifier, for: indexPath) as? HomePostCell else { return UICollectionViewCell() }
        cell.post = posts[indexPath.row]
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 585)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 7
    }
}
