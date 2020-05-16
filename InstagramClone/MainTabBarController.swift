//
//  MainTabBarController.swift
//  InstagramClone
//
//  Created by Ahmed Amr on 7/30/19.
//  Copyright © 2019 Ahmed Amr. All rights reserved.
//

import UIKit
import Firebase
class MainTabBarController: UITabBarController, UITabBarControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let navController = UINavigationController(rootViewController: LoginController())
                navController.modalPresentationStyle = .fullScreen
                self.present(navController, animated: true, completion: nil)
            }
            return
        }
        setupViewControllers()
    }

    func setupViewControllers() {
        let homeNavController = templateNavControllerForTabbar(viewController: HomeController(collectionViewLayout: UICollectionViewFlowLayout()), unselectedImage: #imageLiteral(resourceName: "home_unselected"), selectedImage: #imageLiteral(resourceName: "home_selected"))

        let searchNavController = templateNavControllerForTabbar(viewController: UserSearchController(collectionViewLayout: UICollectionViewFlowLayout()), unselectedImage: #imageLiteral(resourceName: "search_unselected"), selectedImage: #imageLiteral(resourceName: "search_selected"))

        let createPostNavController = templateNavControllerForTabbar(viewController: UIViewController(), unselectedImage: #imageLiteral(resourceName: "plus_unselected"), selectedImage: #imageLiteral(resourceName: "plus_unselected"))

        let likesNavController = templateNavControllerForTabbar(viewController: UIViewController(), unselectedImage: #imageLiteral(resourceName: "like_unselected"), selectedImage: #imageLiteral(resourceName: "like_selected"))

        let userProfileNavController =  templateNavControllerForTabbar(viewController: UserProfileController(collectionViewLayout: UICollectionViewFlowLayout()), unselectedImage: #imageLiteral(resourceName: "profile_unselected"), selectedImage: #imageLiteral(resourceName: "profile_selected"))

        tabBar.tintColor = .black
        viewControllers = [homeNavController, searchNavController, createPostNavController, likesNavController, userProfileNavController]

        guard let tabBarItems = tabBar.items else { return }
        for item in tabBarItems {
            item.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
        }
    }

    private func templateNavControllerForTabbar(viewController: UIViewController, unselectedImage: UIImage, selectedImage: UIImage) -> UINavigationController {
        let navController = UINavigationController(rootViewController: viewController)
        navController.tabBarItem.image = unselectedImage
        navController.tabBarItem.selectedImage = selectedImage
        return navController
    }

    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let index = viewControllers?.firstIndex(of: viewController)
        if index == 2 {
            let layout = UICollectionViewFlowLayout()
            let photoSelectorController = PhotoSelectorController(collectionViewLayout: layout)
            let photoSelectorNavController = UINavigationController(rootViewController: photoSelectorController)
            present(photoSelectorNavController, animated: true, completion: nil)
            return false
        }
        return true
    }

}
