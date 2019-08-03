//
//  Colors.swift
//  InstagramClone
//
//  Created by Ahmed Amr on 7/28/19.
//  Copyright © 2019 Ahmed Amr. All rights reserved.
//

import UIKit
import Firebase

extension UIColor {
    //Signup Colors
    static let dimmedSignupButton = UIColor(hex: 0x95ccf4)
    static let signupButton = UIColor(hex: 0x1199ed)
    static let signupTextfield = UIColor(white: 0, alpha: 0.03)

    //Signin Color
    static let logoBackground = UIColor(hex: 0x0078af)
    //background
    static let background = UIColor(hex: 0xf9f9f9)
}

class FirebaseHelper {
    //Database
    static let usersDatabase = Database.database().reference().child("users")
    //Storage
    static let profileImages = Storage.storage().reference().child("profile_images")
}
