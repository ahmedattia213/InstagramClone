//
//  UserProfileController.swift
//  InstagramClone
//
//  Created by Ahmed Amr on 7/30/19.
//  Copyright © 2019 Ahmed Amr. All rights reserved.
//

import UIKit
import Firebase
class UserProfileController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var user: User? {
        didSet {
            self.navigationItem.title = self.user?.username
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        fetchUser()
        collectionView.register(UserProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: UserProfileHeader.reuseId)
    }
    
    private func fetchUser() {
        guard let currentUserUid = Auth.auth().currentUser?.uid else { return }
        FirebaseHelper.usersDatabase.child(currentUserUid).observeSingleEvent(of: .value, with: { (snapshot) in
            guard let snapshotValue = snapshot.value as? [String : Any] else { return }
            self.user = User(dictionary: snapshotValue)
            self.collectionView.reloadData()
        }) { (err) in
            print("Failed to fetch user: ",err)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: UserProfileHeader.reuseId, for: indexPath) as! UserProfileHeader
        header.user = self.user
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 200)
    }
}

struct User {
    let username: String
    let profileImageUrl: String
    
    init(dictionary: [String: Any]) {
        self.username = dictionary["username"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
    }
}
