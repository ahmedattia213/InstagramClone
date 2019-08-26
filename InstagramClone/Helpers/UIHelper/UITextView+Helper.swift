//
//  UITextView+Helper.swift
//  InstagramClone
//
//  Created by Ahmed Amr on 3/3/19.
//  Copyright © 2019 Ahmed Amr. All rights reserved.
//

import UIKit

extension UITextView {
    convenience init(text: String?, font: UIFont?, color: UIColor?, isEditable: Bool = true) {
        self.init(frame: .zero)
        self.text = text
        self.textColor = color
        self.font = font
        self.backgroundColor = .clear
        self.isEditable = isEditable
    }
}

extension UITextField {
    convenience init(placeholder: String = "", font: UIFont? = nil, backgroundColor: UIColor = .clear, borderStyle: UITextField.BorderStyle = .none) {
        self.init(frame: .zero)
        self.placeholder = placeholder
        self.backgroundColor = backgroundColor
        self.borderStyle = borderStyle
        if let font = font {
            self.font = font
        }
    }
}
