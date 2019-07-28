//
//  UIView+Anchors.swift
//  Youtube
//
//  Edited by Ahmed Amr on 3/3/19.
//  Credits to Brian Voong
//  Copyright © 2019 Ahmed Amr. All rights reserved.

import UIKit

extension UIView {
    
    func addSubviews(_ views: UIView...) {
        views.forEach { addSubview($0) }
    }
    
    public func fillSuperview() {
        translatesAutoresizingMaskIntoConstraints = false
        if let superview = superview {
            leftAnchor.constraint(equalTo: superview.leftAnchor).isActive = true
            rightAnchor.constraint(equalTo: superview.rightAnchor).isActive = true
            topAnchor.constraint(equalTo: superview.topAnchor).isActive = true
            bottomAnchor.constraint(equalTo: superview.bottomAnchor).isActive = true
        }
    }
    
    public func anchorTopLeftWidthAndHeight(top: NSLayoutYAxisAnchor? = nil, left: NSLayoutXAxisAnchor? = nil, topConstant: CGFloat, leftConstant: CGFloat,width: CGFloat, height: CGFloat) {
        anchor(top, left: left, bottom: nil, right: nil, topConstant: topConstant, leftConstant: leftConstant, bottomConstant: 0, rightConstant: 0, widthConstant: width, heightConstant: height)
    }
    
    public func anchorTopRightWidthAndHeight(top: NSLayoutYAxisAnchor? = nil, right: NSLayoutXAxisAnchor? = nil, topConstant: CGFloat, rightConstant: CGFloat,width: CGFloat, height: CGFloat) {
        anchor(top, left: nil, bottom: nil, right: right, topConstant: topConstant, leftConstant: 0, bottomConstant: 0, rightConstant: rightConstant, widthConstant: width, heightConstant: height)
    }
    
    public func anchorBottomLeftWidthAndHeight(width: CGFloat, height: CGFloat) {
        anchor(nil, left: nil, bottom: nil, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: width, heightConstant: height)
        if let superview = superview {
            leftAnchor.constraint(equalTo: superview.leftAnchor).isActive = true
            bottomAnchor.constraint(equalTo: superview.bottomAnchor).isActive = true
        }
    }
    public func anchorBottomRightWidthAndHeight(width: CGFloat, height: CGFloat) {
        anchor(nil, left: nil, bottom: nil, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: width, heightConstant: height)
        if let superview = superview {
            rightAnchor.constraint(equalTo: superview.rightAnchor).isActive = true
            bottomAnchor.constraint(equalTo: superview.bottomAnchor).isActive = true
        }
    }
    
    public func anchorCenterYLeftWidthHeight(width: CGFloat, height: CGFloat) {
        anchorCenterYToSuperview()
        anchor(nil, left: nil, bottom: nil, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: width, heightConstant: height)
        
    }
    public func anchorCenterYLeftRightHeight(height: CGFloat) {
        anchorCenterYToSuperview()
        anchor(nil, left: nil, bottom: nil, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: height)
        
    }
    public func anchorTopLeftRight() {
        anchorLeftRight()
        if let superview = superview {
            topAnchor.constraint(equalTo: superview.topAnchor).isActive = true
        }
    }
    
    public func anchorBottomLeftRight() {
        anchorLeftRight()
        if let superview = superview {
            bottomAnchor.constraint(equalTo: superview.bottomAnchor).isActive = true
        }
    }
    
    public func anchorTopLeftRightAndHeight(heightConstant: CGFloat = 0) {
        anchorTopLeftRight()
        _ = anchorWithReturnAnchors(nil, left: nil, bottom: nil, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: heightConstant)
    }
    
    public func anchorBottomLeftRightAndHeight(heightConstant: CGFloat = 0) {
        anchorBottomLeftRight()
        _ = anchorWithReturnAnchors(nil, left: nil, bottom: nil, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: heightConstant)
    }
    
    public func anchorLeftRight() {
        translatesAutoresizingMaskIntoConstraints = false
        if let superview = superview {
            leftAnchor.constraint(equalTo: superview.leftAnchor).isActive = true
            rightAnchor.constraint(equalTo: superview.rightAnchor).isActive = true
        }
    }
    
    public func anchor(_ top: NSLayoutYAxisAnchor? = nil, left: NSLayoutXAxisAnchor? = nil, bottom: NSLayoutYAxisAnchor? = nil, right: NSLayoutXAxisAnchor? = nil, topConstant: CGFloat = 0, leftConstant: CGFloat = 0, bottomConstant: CGFloat = 0, rightConstant: CGFloat = 0, widthConstant: CGFloat = 0, heightConstant: CGFloat = 0, centerXInSuperView: Bool = false, centerYInSuperView: Bool = false) {
        translatesAutoresizingMaskIntoConstraints = false
        
        _ = anchorWithReturnAnchors(top, left: left, bottom: bottom, right: right, topConstant: topConstant, leftConstant: leftConstant, bottomConstant: bottomConstant, rightConstant: rightConstant, widthConstant: widthConstant, heightConstant: heightConstant)
        if centerXInSuperView {
            anchorCenterXToSuperview()
        }
        if centerYInSuperView {
            anchorCenterYToSuperview()
        }
    }
    
    public func anchorWidthHeight(widthConstant: CGFloat = 0, heightConstant: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        anchor(nil, left: nil, bottom: nil, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: widthConstant, heightConstant: heightConstant)
    }
    
    public func anchorWithReturnAnchors(_ top: NSLayoutYAxisAnchor? = nil, left: NSLayoutXAxisAnchor? = nil, bottom: NSLayoutYAxisAnchor? = nil, right: NSLayoutXAxisAnchor? = nil, topConstant: CGFloat = 0, leftConstant: CGFloat = 0, bottomConstant: CGFloat = 0, rightConstant: CGFloat = 0, widthConstant: CGFloat = 0, heightConstant: CGFloat = 0) -> [NSLayoutConstraint] {
        translatesAutoresizingMaskIntoConstraints = false
        
        var anchors = [NSLayoutConstraint]()
        
        if let top = top {
            anchors.append(topAnchor.constraint(equalTo: top, constant: topConstant))
        }
        
        if let left = left {
            anchors.append(leftAnchor.constraint(equalTo: left, constant: leftConstant))
        }
        
        if let bottom = bottom {
            anchors.append(bottomAnchor.constraint(equalTo: bottom, constant: -bottomConstant))
        }
        
        if let right = right {
            anchors.append(rightAnchor.constraint(equalTo: right, constant: -rightConstant))
        }
        
        if widthConstant > 0 {
            anchors.append(widthAnchor.constraint(equalToConstant: widthConstant))
        }
        
        if heightConstant > 0 {
            anchors.append(heightAnchor.constraint(equalToConstant: heightConstant))
        }
        
        anchors.forEach({$0.isActive = true})
        
        return anchors
    }
    
    public func anchorCenterXToSuperview(constant: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        if let anchor = superview?.centerXAnchor {
            centerXAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
        }
    }
    
    public func anchorCenterYToSuperview(constant: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        if let anchor = superview?.centerYAnchor {
            centerYAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
        }
    }
    
    public func anchorCenterSuperview(constantX: CGFloat = 0, constantY: CGFloat = 0) {
        anchorCenterXToSuperview(constant: constantX)
        anchorCenterYToSuperview(constant: constantY)
    }
    
    public func anchorCenterWithWidthAndHeight(width: CGFloat, height: CGFloat) {
        anchorCenterSuperview()
        anchor(nil, left: nil, bottom: nil, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: width, heightConstant: height)
    }
    
    public func anchorCenterWidthAndHeight(widthConstant: CGFloat = 0, heightConstant: CGFloat = 0) {
        anchorCenterSuperview()
        anchorWidthHeight(widthConstant: widthConstant, heightConstant: heightConstant)
    }
}
