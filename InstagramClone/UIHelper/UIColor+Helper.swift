//
//  UIColor+Helper.swift
//  InstagramClone
//
//  Created by Ahmed Amr on 3/3/19.
//  Copyright © 2019 Ahmed Amr. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(redValue: CGFloat , greenValue: CGFloat , blueValue: CGFloat, alphaValue: CGFloat) {
        self.init(red: redValue/255, green: greenValue/255, blue: blueValue/255, alpha: alphaValue)
    }
    
    convenience init(hex : Int ) {
        let (red, green, blue) = (CGFloat((hex >> 16) & 0xFF),CGFloat((hex >> 8) & 0xFF),CGFloat(hex & 0xFF))
        self.init(redValue: red, greenValue: green, blueValue: blue, alphaValue: 1.0)
    }
    
    convenience init(hex: Int, alpha: CGFloat) {
        let (red, green, blue) = (CGFloat((hex >> 16) & 0xFF),CGFloat((hex >> 8) & 0xFF),CGFloat(hex & 0xFF))
        self.init(redValue: red, greenValue: green, blueValue: blue, alphaValue: alpha)
    }
    
}
