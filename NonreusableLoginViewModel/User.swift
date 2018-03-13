//
//  User.swift
//  NonreusableLoginViewModel
//
//  Created by fadi on 3/13/18.
//  Copyright © 2018 fadi. All rights reserved.
//

import UIKit

struct User: Equatable, Hashable {
    
    var userName: String
    var email: String
    var phone: String
    
    static func ==(lhs: User, rhs: User) -> Bool {
        return (lhs.userName == rhs.userName) &&
               (lhs.email == rhs.email) &&
               (lhs.phone == rhs.phone)
    }
    
    var hashValue: Int {
        return userName.hashValue + email.hashValue + phone.hashValue
    }
}
