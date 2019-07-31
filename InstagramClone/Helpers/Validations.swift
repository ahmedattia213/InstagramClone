//
//  Validations.swift
//  InstagramClone
//
//  Created by Ahmed Amr on 7/31/19.
//  Copyright © 2019 Ahmed Amr. All rights reserved.
//

import Foundation

class ValidationsHelper {
    
    static func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    static func isValidPassword(_ password: String) -> Bool {
        return password.count > 5
    }
    
    static func isValidUsername(_ username: String) -> Bool {
        return username.count > 2
    }
}

