//
//  UserSearchController.swift
//  InstagramClone
//
//  Created by Ahmed Amr on 10/7/19.
//  Copyright © 2019 Ahmed Amr. All rights reserved.
//

import UIKit

class UserSearchController: UICollectionViewController {

    let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search"
        searchBar.setTextFieldColor(color: UIColor(hex: 0xebebeb, alpha: 0.5))
        return searchBar
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        navigationController?.navigationBar.barTintColor = .background
        navigationController?.navigationBar.addSubview(searchBar)
        let navBar = navigationController?.navigationBar
        searchBar.anchor(navBar?.topAnchor, left: navBar?.leftAnchor, bottom: navBar?.bottomAnchor, right: navBar?.rightAnchor, leftConstant: 12, rightConstant: 10)
    }
}
