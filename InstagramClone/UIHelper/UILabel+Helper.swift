//
//  UILabel+Helper.swift
//  Youtube
//
//  Created by Ahmed Amr on 3/3/19.
//  Copyright © 2019 Ahmed Amr. All rights reserved.
//

import UIKit

extension UILabel {
    convenience init(text: String? , font: UIFont?, color: UIColor?,textAlignment: NSTextAlignment? = nil, numberOfLines: Int? = 1 ) {
        self.init(frame: .zero)
        self.text = text
        self.font = font
        self.textColor = color
        self.textAlignment = textAlignment ?? .left
        self.numberOfLines = numberOfLines ?? 1
    }
}
