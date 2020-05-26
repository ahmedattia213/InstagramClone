//
//  UserProfileController.swift
//  InstagramClone
//
//  Created by Ahmed Amr on 7/30/19.
//  Copyright © 2019 Ahmed Amr. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher

class UserProfileController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    var posts = [Post]() {
        didSet {
            self.user?.posts = posts.count
        }
    }

    var user: User? {
        didSet {
            self.navigationItem.title = self.user?.username
            observePosts()
            setupNavbar()
            observeFollowing()
            observeFollowers()
        }
    }
    var following = [String]() {
        didSet {
            self.user?.followingCount = following.count
        }
    }
    var followers = [String]() {
        didSet {
            self.user?.followerCount = followers.count
        }
    }
 
    func observeFollowing() {
        guard let user = user else { return }
        let followingRef = FirebaseHelper.usersFollowing.child(user.uid)
        followingRef.observe(.childAdded, with: { (snapshot) in
            if !self.following.contains(snapshot.key) {
                self.following.append(snapshot.key)
            }
            self.collectionView.reloadData()
        }) { (err) in
            print("ERROR ",err)
        }

    }
    func observeFollowers() {
        guard let user = user else { return }
        let followerRef = FirebaseHelper.usersFollowers.child(user.uid)
        followerRef.observe(.childAdded, with: { (snapshot) in
            print(snapshot)
            if !self.followers.contains(snapshot.key) {
                self.followers.append(snapshot.key)
            }
            self.collectionView.reloadData()

        }) { (err) in
            print("ERROR ",err)
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        checkIfUserExists()
        setupCollectionView()
        setupLogoutButton()
    }

    private func checkIfUserExists() {
        if self.user == nil {
            fetchUser(uid: Auth.auth().currentUser?.uid ?? "")
        }
    }
    private func setupCollectionView() {
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .background
        collectionView.register(UserProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: UserProfileHeader.reuseId)
        collectionView.register(UserProfilePhotoCell.self, forCellWithReuseIdentifier: UserProfilePhotoCell.reuseIdentifier)
    }

    private func observePosts() {
        guard let user = self.user else { return }
        FirebaseHelper.observePostsWithUid(user, completionHandler: { (newPost) in
            if let newPost = newPost {
                if !self.posts.contains(where: {$0.key == newPost.key}) {
                    self.posts.insert(newPost, at: 0)
                    self.collectionView.reloadData()
                }
            }
        }) { (err) in
            if let err = err {
                print(err)
            }
        }
    }

    private func setupLogoutButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "gear"), style: .plain, target: self, action: #selector(handleLogout))
    }
    private func setupNavbar() {
        navigationController?.navigationBar.barTintColor = .background
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    }

    private func fetchUser(uid: String) {
        FirebaseHelper.fetchUserWithUid(uid) { (user) in
            self.user = user
            self.collectionView.reloadData()
        }
    }

    @objc func handleLogout() {
        print("Logout")
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let logoutAction = UIAlertAction(title: "Log Out", style: .destructive) { (_) in
            print("Loggin OUT")
            do {
                try Auth.auth().signOut()
                let navController = UINavigationController(rootViewController: LoginController())
                navController.modalPresentationStyle = .fullScreen
                self.present(navController, animated: true, completion: nil)
            } catch let signoutError {
                print("Failed to signout: ", signoutError)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(logoutAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserProfilePhotoCell.reuseIdentifier, for: indexPath) as? UserProfilePhotoCell else { return UICollectionViewCell()}
        cell.post = self.posts[indexPath.row]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width-2)/3
        return CGSize(width: width, height: width)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: UserProfileHeader.reuseId, for: indexPath) as? UserProfileHeader {
            header.user = self.user
            return header
        }
        return UICollectionReusableView()
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = UserFeedController(collectionViewLayout: UICollectionViewFlowLayout())
        vc.posts = posts
        vc.user = posts[indexPath.row].user
        vc.indexPath = indexPath
        navigationController?.pushViewController(vc, animated: true)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 250)
    }
}
