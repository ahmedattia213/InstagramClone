//
//  HomeController.swift
//  InstagramClone
//
//  Created by Ahmed Amr on 9/30/19.
//  Copyright © 2019 Ahmed Amr. All rights reserved.
//

import UIKit

class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    var posts = [Post]()

    override func viewDidLoad() {
        setupNavBar()
        setupCollectionView()
        observePosts()
    }

    private func setupNavBar() {
        navigationController?.navigationBar.barTintColor = .background
        let logoColour = UIColor(redValue: 18, greenValue: 18, blueValue: 18, alphaValue: 1)
        let imageView = UIImageView(image: #imageLiteral(resourceName: "Instagram_logo_white"), contentMode: .scaleAspectFit, tintColour: logoColour)
        navigationItem.titleView = imageView
    }

    private func observePosts() {
        guard let uid = FirebaseHelper.currentUserUid else { return }
        let postsRef = FirebaseHelper.userPostsDatabase.child(uid)
        postsRef.queryOrdered(byChild: "creationDate").observe(.childAdded, with: { (snapshot) in
            guard let dict = snapshot.value as? [String: Any] else { return }
            let newPost = Post(dictionary: dict)
            self.posts.insert(newPost, at: 0)
            self.collectionView.reloadData()
        }) { (err) in
            print("Failed to retreive latest post: ", err)
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
        return CGSize(width: view.frame.width, height: view.frame.height*0.8)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 7
    }
}


