//
//  UIStackView+Helper.swift
//  BestFit
//
//  Created by Ahmed Amr on 7/16/19.
//  Copyright © 2019 BestFit GmbH. All rights reserved.
//

import UIKit

extension UIStackView {
    convenience init(axis: NSLayoutConstraint.Axis? = NSLayoutConstraint.Axis.horizontal , alignment: Alignment? = .fill, distribution: Distribution? = .fill, spacing: CGFloat? = 0, arrangedSubviews: [UIView]) {
        self.init(arrangedSubviews: arrangedSubviews)
        if let axis = axis {
            self.axis = axis
        }
        if let alignment = alignment {
            self.alignment = alignment
        }
        if let distribution = distribution {
            self.distribution = distribution
        }
        if let spacing = spacing {
            self.spacing = spacing
        }
    }
    
    func addArrangedSubviews(_ views: UIView...) {
        views.forEach { addArrangedSubview($0) }
    }
    func removeAllArrangedSubviews() {
        let removedSubviews = arrangedSubviews.reduce([]) { (allSubviews, subview) -> [UIView] in
            self.removeArrangedSubview(subview)
            return allSubviews + [subview]
        }
        removedSubviews.forEach({ $0.removeFromSuperview() })
    }
}
