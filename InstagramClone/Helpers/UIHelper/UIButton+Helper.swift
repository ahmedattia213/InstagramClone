//
//  UIButton+Helper.swift
//  InstagramClone
//
//  Created by Ahmed Amr on 4/16/19.
//  Copyright © 2019 Ahmed Amr. All rights reserved.
//

import UIKit

extension UIButton {
    static public func systemButton(size: Int? = nil, title: String? = nil, image: UIImage? = nil, titleColor: UIColor? = .white,
                                    tintColor: UIColor? = nil, backgroundColor: UIColor = .clear, font: UIFont? = nil, target: Any? = nil, selector: Selector? = nil) -> UIButton {
        let button = UIButton(type: .system)
        if let size = size {
            button.frame = CGRect(x: 0, y: 0, width: size, height: size)
        }
        button.setTitle(title, for: .normal)
        button.setImage(image, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.setTitleColor(titleColor, for: .normal)
        button.titleLabel?.font = font
        button.backgroundColor = backgroundColor
        if let tintColor = tintColor {
            button.tintColor = tintColor
        }
        if let selector = selector {
            button.addTarget(target, action: selector, for: .touchUpInside)
        }
        return button
    }
}
