//
//  Firebase+Helper.swift
//  InstagramClone
//
//  Created by Ahmed Amr on 9/16/19.
//  Copyright © 2019 Ahmed Amr. All rights reserved.
//

import Firebase

class FirebaseHelper {
    //Current User Uid
    static let currentUserUid = Auth.auth().currentUser?.uid
    //Database
    static let usersDatabase = Database.database().reference().child("users")
    static let usersFollowing = Database.database().reference().child("following")
    //Storage
    static let profileImages = Storage.storage().reference().child("profile_images")
    static let userPostsStorage = Storage.storage().reference().child("user_posts")
    static let userPostsDatabase = Database.database().reference().child("user_posts")

    //Fetching User with Uid
    static func fetchUserWithUid(_ uid: String, completionHandler: @escaping (User) -> Void) {
          self.usersDatabase.child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
              guard let dict = snapshot.value as? [String: Any] else { return }
            let userFetched = User(uid: uid, dictionary: dict)
              completionHandler(userFetched)
          }) { (err) in
               print("Failed to fetch current user: ", err)
          }
      }

    static func observePostsWithUid(_ user: User, completionHandler: @escaping (Post?) -> Void, failureHandler: @escaping(_ errorMessage: String?) -> Void) {
        let postsRef = FirebaseHelper.userPostsDatabase.child(user.uid)
          postsRef.queryOrdered(byChild: "creationDate").observe(.childAdded, with: { (snapshot) in
              guard let dict = snapshot.value as? [String: Any] else { return }
            let newPost = Post(user: user, dictionary: dict)
              completionHandler(newPost)
              failureHandler(nil)
          }) { (err) in
            completionHandler(nil)
            failureHandler(err.localizedDescription)
              print("Failed to retreive latest post: ", err)
          }
      }
}
