//
//  FirebaseHelper.swift
//  InstagramClone
//
//  Created by Ahmed Amr on 9/16/19.
//  Copyright © 2019 Ahmed Amr. All rights reserved.
//

import Firebase

class FirebaseHelper {
    static let currentUserUid = Auth.auth().currentUser?.uid
    //Database
    static let usersDatabase = Database.database().reference().child("users")
    //Storage
    static let profileImages = Storage.storage().reference().child("profile_images")
    static let userPostsStorage = Storage.storage().reference().child("user_posts")
    static let userPostsDatabase = Database.database().reference().child("user_posts")
}
