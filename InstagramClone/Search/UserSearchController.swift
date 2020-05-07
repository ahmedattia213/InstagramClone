//
//  UserSearchController.swift
//  InstagramClone
//
//  Created by Ahmed Amr on 10/7/19.
//  Copyright © 2019 Ahmed Amr. All rights reserved.
//

import UIKit
import Firebase

class UserSearchController: UICollectionViewController, UICollectionViewDelegateFlowLayout,
UISearchBarDelegate {

    var users = [User]()
    var filteredUsers = [User]()
    var cancelWidthAnchor: NSLayoutConstraint?

    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search"
        searchBar.setTextFieldColor(color: UIColor(hex: 0xebebeb, alpha: 0.5))
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = UIColor(hex: 0xebebeb, alpha: 0.5)
        searchBar.delegate = self
        return searchBar
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupNavBar()
        fetchUsers()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchBar.isHidden = false
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        showCancelButton()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            self.filteredUsers = users
        } else {
            self.filteredUsers = self.users.filter { (user) -> Bool in
                return user.username!.localizedCaseInsensitiveContains(searchText)
            }
        }
        self.collectionView.reloadData()
    }

    private func fetchUsers() {
        let ref = FirebaseHelper.usersDatabase
        ref.observe(.childAdded, with: { (snapshot) in
            guard let dicts = snapshot.value as? [String: Any] else { return }
            let user = User(uid: snapshot.key, dictionary: dicts)
            if Auth.auth().currentUser?.uid == user.uid {
                return
            }
            self.users.append(user)
            self.users = self.users.sorted(by: { $0.username!.lowercased() < $1.username!.lowercased()})
            self.filteredUsers = self.users
            self.collectionView.reloadData()
        }) { (err) in
            print("Failed to fetch in search ", err)
        }
    }
    
    private func setupCollectionView() {
        collectionView.contentInset = UIEdgeInsets(top: 6, left: 0, bottom: 0, right: 0)
        collectionView.backgroundColor = .white
        collectionView.register(SearchCell.self, forCellWithReuseIdentifier: SearchCell.reuseIdentifier)
        collectionView.alwaysBounceVertical = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.keyboardDismissMode = .onDrag
    }
    
    lazy var cancelButton = UIButton.systemButton( title: "Cancel", titleColor: .black, backgroundColor: .clear, font: UIFont.systemFont(ofSize: 15), target: self, selector: #selector(handleEndFiltering))

    @objc func handleEndFiltering() {
        hideCancelButton()
        searchBar.resignFirstResponder()
    }

    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        handleEndFiltering()
    }

    private func setupNavBar() {
        navigationController?.navigationBar.barTintColor = .background
        navigationController?.navigationBar.addSubview(searchBar)
        navigationController?.navigationBar.addSubview(cancelButton)
        let navBar = navigationController?.navigationBar
        searchBar.anchor(navBar?.topAnchor, left: navBar?.leftAnchor, bottom: navBar?.bottomAnchor, right: cancelButton.leftAnchor, leftConstant: 12, rightConstant: 5)
        cancelButton.anchor(navBar?.topAnchor, bottom: navBar?.bottomAnchor, right: navBar?.rightAnchor, rightConstant: 5)
        cancelWidthAnchor = cancelButton.widthAnchor.constraint(equalToConstant: 0)
        cancelWidthAnchor?.isActive = true
    }

    private func showCancelButton() {
        self.cancelWidthAnchor?.constant = 60
        UIView.animate(withDuration: 0.3) {
            self.navigationController?.navigationBar.layoutIfNeeded()
        }
    }
    private func hideCancelButton() {
        self.cancelWidthAnchor?.constant = 0
        UIView.animate(withDuration: 0.3) {
            self.navigationController?.navigationBar.layoutIfNeeded()
        }
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredUsers.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCell.reuseIdentifier, for: indexPath) as? SearchCell else { return UICollectionViewCell() }
        cell.user = filteredUsers[indexPath.row]
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let user = filteredUsers[indexPath.row]
        searchBar.isHidden = true
        searchBar.resignFirstResponder()
        let userProfileController = UserProfileController(collectionViewLayout: UICollectionViewFlowLayout())
        userProfileController.user = filteredUsers[indexPath.row]
        navigationController?.pushViewController(userProfileController, animated: true)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 70)
    }
}
