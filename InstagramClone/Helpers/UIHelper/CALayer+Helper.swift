//
//  CALayer+Helper.swift
//  InstagramClone
//
//  Created by Ahmed Amr on 5/14/19.
//  Copyright © 2019 Ahmed Amr. All rights reserved.
//

import UIKit

extension CAGradientLayer {
    convenience init(colors: [CGColor]?, locations: [NSNumber]? = nil, startPoint: CGPoint = CGPoint(x: 0.5, y: 0), endPoint: CGPoint = CGPoint(x: 0.5, y: 1.0), frame: CGRect = .zero) {
        self.init()
        self.frame = frame
        self.colors = colors
        self.locations = locations
        self.startPoint = startPoint
        self.endPoint = endPoint
    }
}
