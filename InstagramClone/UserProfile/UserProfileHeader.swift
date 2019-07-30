//
//  UserProfileHeader.swift
//  InstagramClone
//
//  Created by Ahmed Amr on 7/30/19.
//  Copyright © 2019 Ahmed Amr. All rights reserved.
//

import UIKit

class UserProfileHeader: BaseReusableView {
    static let reuseId = "UserProfileHeaderReuseId"
    
    var user: User? {
        didSet {
         setupProfileImageView() 
        }
    }
    let profileImageView = UIImageView(image: nil, contentMode: .scaleAspectFill)
    
    override func setupViews() {
        backgroundColor = UIColor(white: 0, alpha: 0.05)
        addSubview(profileImageView)
        profileImageView.anchor(topAnchor, left: leftAnchor, topConstant: 12, leftConstant: 12, widthConstant: 80, heightConstant: 80)
        profileImageView.backgroundColor = .red
        profileImageView.roundCircular(width: 80)
    }
    
    private func setupProfileImageView() {
        guard let profileImageUrlString = user?.profileImageUrl else { return }
        guard let profileImageUrl = URL(string: profileImageUrlString) else { return }
        URLSession.shared.dataTask(with: profileImageUrl) { (data, response, err) in
            if let err = err {
                print("Failed to retrieve image from URL: ",err)
                return
            }
            guard let data = data else { return }
            let image = UIImage(data: data)
            DispatchQueue.main.async {
                self.profileImageView.image = image
            }
            }.resume()
    }
   
}
