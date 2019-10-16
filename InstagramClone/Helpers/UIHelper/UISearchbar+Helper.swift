//
//  UISearchbar+Helper.swift
//  InstagramClone
//
//  Created by Ahmed Amr on 10/7/19.
//  Copyright © 2019 Ahmed Amr. All rights reserved.
//

import UIKit

extension UISearchBar {
    func getTextField() -> UITextField? { return value(forKey: "searchField") as? UITextField }
    func setTextFieldColor(color: UIColor) {
        guard let textField = getTextField() else { return }
        switch searchBarStyle {
        case .minimal:
            textField.layer.backgroundColor = color.cgColor
            textField.layer.cornerRadius = 6
        case .prominent, .default: textField.backgroundColor = color
        @unknown default: break
        }
    }
}
